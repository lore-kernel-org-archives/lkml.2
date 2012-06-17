Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2FQKhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 06:37:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51623 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab2FQKha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 06:37:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1206161811020.797@chino.kir.corp.google.com>
References: <1338438844-5022-1-git-send-email-andi@firstfloor.org>
	<1339234803-21106-1-git-send-email-tdmackey@twitter.com>
	<alpine.DEB.2.00.1206091917580.7832@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1206161811020.797@chino.kir.corp.google.com>
Date: Sun, 17 Jun 2012 13:37:29 +0300
X-Google-Sender-Auth: MESm4CiZqDrV_rpNV76lWBSa_lU
Message-ID: <CAOJsxLGhQSZjY8jcL7tB2-oicak-H68CW5S8OOMz8cEh=m5hjg@mail.gmail.com>
Subject: Re: [PATCH v5] slab/mempolicy: always use local policy from interrupt context
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: David Mackey <tdmackey@twitter.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, cl@linux.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 4:11 AM, David Rientjes <rientjes@google.com> wrote:
> On Sat, 9 Jun 2012, David Rientjes wrote:
>
>> On Sat, 9 Jun 2012, David Mackey wrote:
>>
>> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> > index f15c1b2..cb0b230 100644
>> > --- a/mm/mempolicy.c
>> > +++ b/mm/mempolicy.c
>> > @@ -1602,8 +1602,14 @@ static unsigned interleave_nodes(struct mempolicy *policy)
>> >   * task can change it's policy.  The system default policy requires no
>> >   * such protection.
>> >   */
>> > -unsigned slab_node(struct mempolicy *policy)
>> > +unsigned slab_node(void)
>> >  {
>> > +   struct mempolicy *policy;
>> > +
>> > +   if (in_interrupt())
>> > +           return numa_node_id();
>> > +
>> > +   policy = current->mempolicy;
>> >     if (!policy || policy->flags & MPOL_F_LOCAL)
>> >             return numa_node_id();
>> >
>>
>> Should probably be numa_mem_id() in both these cases for
>> CONFIG_HAVE_MEMORYLESS_NODES, but it won't cause a problem in this form
>> either.
>>
>> Acked-by: David Rientjes <rientjes@google.com>
>>
>
> Still missing from linux-next, who's going to pick this up?

I'm going to pick it up. I've been postponing merging it until dust
has settled from Christoph's "common slab" patch series.
