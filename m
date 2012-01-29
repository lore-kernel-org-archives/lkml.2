Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2A2Rgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 12:36:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52089 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2A2Rgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 12:36:37 -0500
MIME-Version: 1.0
In-Reply-To: <1327639925-12920-18-git-send-email-ebiederm@xmission.com>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org> <1327639925-12920-18-git-send-email-ebiederm@xmission.com>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Sun, 29 Jan 2012 19:36:06 +0200
Message-ID: <CAPLs8y9-nA7gZymMkFzOdB6zh0h2hS+dhWu42ciOaHzJ++Z+gg@mail.gmail.com>
Subject: Re: [PATCH 18/29] sysctl: Normalize the root_table data structure.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org,
        Damien Millescamps <damien.millescamps@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 6:51 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Every other directory has a .child member and we look at the .child
> for our entries.  Do the same for the root_table.
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/proc/proc_sysctl.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 7e96a26..88d1b06 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -25,7 +25,14 @@ void proc_sys_poll_notify(struct ctl_table_poll *poll)
>        wake_up_interruptible(&poll->wait);
>  }
>
> -static struct ctl_table root_table[1];
> +static struct ctl_table root_table[] = {
> +       {
> +               .procname = "",
> +               .mode = S_IRUGO|S_IXUGO,

Why not: .mode = S_IFDIR|S_IRUGO|S_IXUGO ?

You change it later and add IFDIR in patch 22/29 because of this
change (from 22/29):
-	if (!table->child) {
+	if (!S_ISDIR(table->mode)) {

but if might as well be done here.


> +               .child = &root_table[1],
> +       },
> +       { }
> +};
>  static struct ctl_table_root sysctl_table_root;
>  static struct ctl_table_header root_table_header = {
>        {{.count = 1,
> @@ -319,7 +326,7 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
>                goto out;
>        }

Somewhere above we have
  struct ctl_table *table = PROC_I(inode)->sysctl_entry;
and sysctl_entry can take two values:
   - NULL: fs/proc/inode.c:proc_alloc_inode()
   - a non-NULL table in: proc_sys_make_inode()

The only inode that can be passed to proc_sys_lookup that can have
table=NULL is the root inode.
In that case head will be &root_table_header.


So head->ctl_table[1] == root_table_header.ctl_table[1] == root_table[1].


>
> -       table = table ? table->child : head->ctl_table;
> +       table = table ? table->child : &head->ctl_table[1];

I think this could be improved to something like this:
/* table == NULL only for the procfs root directory */
table = table ? table->child : &root_table[1];


It's not that important, as this code will go away in a few patches.

>
>        p = find_in_table(table, name);
>        if (!p) {
> @@ -510,7 +517,7 @@ static int proc_sys_readdir(struct file *filp, void *dirent, filldir_t filldir)
>                goto out;
>        }
>
> -       table = table ? table->child : head->ctl_table;
> +       table = table ? table->child : &head->ctl_table[1];

Similar.

>        ret = 0;
>        /* Avoid a switch here: arm builds fail with missing __cmpdi2 */
> @@ -966,7 +973,7 @@ struct ctl_table_header *__register_sysctl_table(
>        spin_lock(&sysctl_lock);
>        header->set = lookup_header_set(root, namespaces);
>        header->attached_by = header->ctl_table;
> -       header->attached_to = root_table;
> +       header->attached_to = &root_table[1];
>        header->parent = &root_table_header;
>        set = header->set;
>        root = header->root;
> --
> 1.7.2.5
>



-- 
 .
..: Lucian
