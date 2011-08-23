Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab1HWJD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:03:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab1HWJD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:03:28 -0400
Date: Tue, 23 Aug 2011 11:03:22 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/5] fs: add netlink notification interface
In-Reply-To: <20110819151528.GB4602@thunk.org>
Message-ID: <alpine.LFD.2.00.1108231046270.4122@dhcp-27-109.brq.redhat.com>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com> <1313669906-14931-2-git-send-email-lczerner@redhat.com> <20110819151528.GB4602@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011, Ted Ts'o wrote:

> On Thu, Aug 18, 2011 at 02:18:22PM +0200, Lukas Czerner wrote:
> > +void fs_nl_send_warning(dev_t dev, unsigned int warntype)
> > +{
> 
> I'm pretty sure this interface isn't going to be sufficient in the
> long run.  I can imagine that people might want to pass in a struct
> inode *, or a struct file * if available, so we could pass back the
> inode number involved, or even the pathname.

Ok, it makes sense to extend the interface a bit. So what about:

voif fs_nl_send_warning(dev_t dev, unsigned int warntype,
			unsigned int flags, void *data);

So we can get the type of the warning, flags which will provide more
information about the waring as for example what type of data are we
attaching, or what type of quota is that etc... And with data we can
easily pass struct inode *, or struct file * or whatever the type of
warning needs for better description of the problem.

> 
> Also, I'd suggesting changing "warning" to "error", since that's what
> most of the things we are sending really are...

I am ok with calling it error, but I do not consider ENOSPC, or
exceeding quota to be an error from the kernel point of view. In
application it is of course an error, but in file system it is just the
state of the things. But anyway it is just my viewpoint and if people
think that it should be called *error* i am ok with that.

> 
> > +	ret = nla_put_u32(skb, FS_NL_A_WARNING, warntype);
> > +	if (ret)
> > +		goto attr_err_out;
> 
> Why not make the warning type to be a string instead of an integer?
> This would make it easier to extend the protocol in the future.

I think that having an ID of the type of the message is important so we
can clearly say what happened without the need of parsing the string.
Otherwise it would be no different than printk's.

I am not sure why would we want to pass string instead. If we want to
pass random errors down this interface I do not think that is going to
be very useful.

> 
> > +	ret = nla_put_u64(skb, FS_NL_A_CAUSED_ID, current_uid());
> > +	if (ret)
> > +		goto attr_err_out;
> 
> I'd also suggest passing back the process id that requested the I/O if
> that's known...

Good point.

> 
> 						- Ted
> 

Thanks!
-Lukas
