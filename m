Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2K1DQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:16:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32179 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2K1DQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:16:30 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=I-iMx3680sAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=3w0Gx6Wee0gA:10 a=9eFvU83qGwu7wdkm_n0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354072588.6276.101.camel@gandalf.local.home>
Subject: Re: [RFC] [PATCH] fix infinite loop; increase robustness of
 debugfs_remove_recursive
From: Steven Rostedt <rostedt@goodmis.org>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Tue, 27 Nov 2012 22:16:28 -0500
In-Reply-To: <20121123171547.GB23670@soda.linbit>
References: <20121123171547.GB23670@soda.linbit>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 18:15 +0100, Lars Ellenberg wrote:
> When toying around with debugfs, intentionally trying to break things,
> I managed to get it into a reproducible endless loop when cleaning up.
> 
> debugfs_remove_recursive() completely ignores that entries found
> on ->d_subdirs may already be d_delete()d, but not yet d_kill()ed.
> 
> In this case, the first two entries found have both been such dentries
> (d_iname = ".", btw), while later in the list there was still a real,
> not yet deleted entry.
> 
> That way, the "goto next_sibling;" did not catch this case,
> the "break the infinit loop if we fail to remove something"
> did not catch it either.
> 
> 
> Disclaimer: I'm not a dentries and inodes guy...

I'm not a dentries or inodes guy either, so I wont comment on the actual
merits of this patch.

> 
> Still, I think the "is this child a non-empty subdir" check
> was just wrong. This is my fix:
> -	if (list_empty(&child->d_subdirs)) 
> +	if (!simple_emty(child))

"simple_empty"

> 
> Also, always trying to __debugfs_remove() the first entry found from
> parent->d_subdirs.next is wrong, we need to skip over any already
> deleted children. I introduced the debugfs_find_next_positive_child()
> helper for this.
> 
> If I understand it correctly, if we do it this way, it can never fail.
> That is, as long as we can be sure that no new dentries will be created
> while we are in debugfs_remove_recursive().
> So the 
> 		if (debugfs_positive(child)) {
>  			/*
>  			 * Avoid infinite loop if we fail to remove
>  			 * one dentry.
> is probably dead code now?
> 
> 
> As an additional fix, to prevent an access after free and resulting Oops,
> I serialize dereferencing of attr->get/set and attr->data with d_delete(),
> using the file->f_dentry->d_parent->d_inode->i_mutex.
> 
> If this file->f_dentry meanwhile has been deleted, simple_attr_read()
> and simple_attr_write() now returns -ESTALE. (Any other error code preferences?)
> 
> 
> With this patch, I was able to
> cd /sys/debugfs/test-module/some/dir
> exec 7< some-file
> rmmod test-module
> cat <&7

I saw this and thought "hmm, I wonder if the trace_events have issues,
as they create debugfs directories and files via modules too". I went
and tried to reproduce but couldn't get passed the rmmod, as the module
count gets incremented for any open files that the module creates. I
take it that you didn't add that feature to your test module.

> 
> without any infinite loops, hangs, oopses or other problems,
> and as expected get an ESTALE for the cat.
> 
> Without the patch, I'll get either an infinite loop and rmmod never
> terminates, or cat oopses.
> 
> 
> If you think this is correct, please comment on the FIXME
> below, and help me write a nice commit message.
> 
> If you think this is still wrong or even makes things worse,
> please help me with a proper fix ;-)
> 
> 
> Patch is against upstream as of yesterday,
> but looks like it still applies way back into 2009, 2.6.3x,
> so if it is correct, it may even qualify for the stable branches?
> 

Now, is there any current user of debugfs that is susceptible for this
bug? I'm not saying that these issues shouldn't be fixed. But I'm also
concerned about exploits and other things that just a root user may
accidentally cause harm. If there's current problem then maybe this
isn't needed for stable. But should probably be fixed for the future.

-- Steve


