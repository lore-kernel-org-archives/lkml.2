Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2AYADw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:03:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2AYADv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:03:51 -0500
Date: Tue, 24 Jan 2012 16:03:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH] KSM: numa awareness sysfs knob
Message-Id: <20120124160350.17b6e92b.akpm@linux-foundation.org>
In-Reply-To: <1327314568-13942-1-git-send-email-pholasek@redhat.com>
References: <1327314568-13942-1-git-send-email-pholasek@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 11:29:28 +0100
Petr Holasek <pholasek@redhat.com> wrote:

> This patch is based on RFC
> 
> https://lkml.org/lkml/2011/11/30/91
> 
> Introduces new sysfs binary knob /sys/kernel/mm/ksm/merge_nodes

It's not binary - it's ascii text!  "boolean" is a better term here ;)

> which control merging pages across different numa nodes.
> When it is set to zero only pages from the same node are merged,
> otherwise pages from all nodes can be merged together (default behavior).
> 
> Typical use-case could be a lot of KVM guests on NUMA machine
> where cpus from more distant nodes would have significant increase
> of access latency to the merged ksm page. Switching merge_nodes
> to 1 will result into these steps:
> 
> 	1) unmerging all ksm pages
> 	2) re-merging all pages from VM_MERGEABLE vmas only within
> 		their NUMA nodes.
> 	3) lower average access latency to merged pages at the
> 	   expense of higher memory usage.
> 
> Every numa node has its own stable & unstable trees because
> of faster searching and inserting. Changing of merge_nodes
> value breaks COW on all current ksm pages.
> 

How useful is this code?  Do you have any performance testing results
to help make the case for merging it?

Should the unmerged case be made permanent and not configurable?  IOW,
what is the argument for continuing to permit the user to merge across
nodes?

Should the code bother doing this unmerge when
/sys/kernel/mm/ksm/merge_nodes is written to?  It would be simpler to
expect the user to configure /sys/kernel/mm/ksm/merge_nodes prior to
using KSM at all?

> @@ -58,6 +58,9 @@ sleep_millisecs  - how many milliseconds ksmd should sleep before next scan
>                     e.g. "echo 20 > /sys/kernel/mm/ksm/sleep_millisecs"
>                     Default: 20 (chosen for demonstration purposes)
>  
> +merge_nodes      - specifies if pages from different numa nodes can be merged
> +                   Default: 1

This documentation would be better if it informed the user about how to
use merge_nodes.  What are the effects of altering it and why might
they wish to do this?

>
> ...
>
> +static ssize_t merge_nodes_store(struct kobject *kobj,
> +				   struct kobj_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	int err;
> +	long unsigned int knob;

Plain old "unsigned long" is more usual.

Better would be to make this "unsigned", to match ksm_merge_nodes.  Use
kstrtouint() below.

>
> ...
>
> @@ -1987,6 +2070,9 @@ static struct attribute *ksm_attrs[] = {
>  	&pages_unshared_attr.attr,
>  	&pages_volatile_attr.attr,
>  	&full_scans_attr.attr,
> +#ifdef CONFIG_NUMA
> +	&merge_nodes_attr.attr,
> +#endif

One might think that with CONFIG_NUMA=n, we just added a pile of
useless codebloat to vmlinux.  But gcc is sneaky and removes the
unreferenced functions.

However while doing so, gcc shows that it reads
Documentation/SubmitChecklist, section 2:

mm/ksm.c:2017: warning: 'merge_nodes_attr' defined but not used

So...

diff -puN mm/ksm.c~ksm-numa-awareness-sysfs-knob-fix mm/ksm.c
--- a/mm/ksm.c~ksm-numa-awareness-sysfs-knob-fix
+++ a/mm/ksm.c
@@ -1973,6 +1973,7 @@ static ssize_t run_store(struct kobject 
 }
 KSM_ATTR(run);
 
+#ifdef CONFIG_NUMA
 static ssize_t merge_nodes_show(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
 {
@@ -2015,6 +2016,7 @@ static ssize_t merge_nodes_store(struct 
 	return count;
 }
 KSM_ATTR(merge_nodes);
+#endif
 
 static ssize_t pages_shared_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
_

