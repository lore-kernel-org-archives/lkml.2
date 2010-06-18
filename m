Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0FRVj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:39:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab0FRVjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:39:25 -0400
Date: Fri, 18 Jun 2010 14:38:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mempolicy: reduce stack size of migrate_pages()
Message-Id: <20100618143851.0661daa2.akpm@linux-foundation.org>
In-Reply-To: <20100616130040.3831.A69D9226@jp.fujitsu.com>
References: <20100616130040.3831.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 13:36:57 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> Now, migrate_pages() are using >500 bytes stack. This patch reduce it.
> 
>    mm/mempolicy.c: In function 'sys_migrate_pages':
>    mm/mempolicy.c:1344: warning: the frame size of 528 bytes is larger than
>    512 bytes
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> ---
>  mm/mempolicy.c |   35 ++++++++++++++++++++++-------------
>  1 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 13b09bd..1116427 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1275,33 +1275,39 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
>  		const unsigned long __user *, new_nodes)
>  {
>  	const struct cred *cred = current_cred(), *tcred;
> -	struct mm_struct *mm;
> +	struct mm_struct *mm = NULL;
>  	struct task_struct *task;
> -	nodemask_t old;
> -	nodemask_t new;
>  	nodemask_t task_nodes;
>  	int err;
> +	NODEMASK_SCRATCH(scratch);
> +	nodemask_t *old = &scratch->mask1;
> +	nodemask_t *new = &scratch->mask2;
>
> +	if (!scratch)
> +		return -ENOMEM;

It doesn't matter in practice, but it makes me all queazy to see code
which plays with pointers which might be NULL.

--- a/mm/mempolicy.c~mempolicy-reduce-stack-size-of-migrate_pages-fix
+++ a/mm/mempolicy.c
@@ -1279,13 +1279,16 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	struct task_struct *task;
 	nodemask_t task_nodes;
 	int err;
+	nodemask_t *old;
+	nodemask_t *new;
 	NODEMASK_SCRATCH(scratch);
-	nodemask_t *old = &scratch->mask1;
-	nodemask_t *new = &scratch->mask2;
 
 	if (!scratch)
 		return -ENOMEM;
 
+	old = &scratch->mask1;
+	new = &scratch->mask2;
+
 	err = get_nodes(old, old_nodes, maxnode);
 	if (err)
 		goto out;
_

