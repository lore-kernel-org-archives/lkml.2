Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0L1LSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:18:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47632 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0L1LS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:18:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZXbKNM8+dyXeVE4XbwQMzy4nXVYwEwuVtVu1AyfFFc4Q03yYtGYlCEsVzHkSSrwxLj
         nkYIrouuj+bashoEyEVlZxZTvm30kP4yJm9Pt09jb3yzMaZK33Nvm2Yfmg+PrgUDdgtf
         WUPM8Mt+OpJwfJgidCXWkABJ+1JNs9Fn7Fe7A=
Date: Tue, 28 Dec 2010 12:18:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH RESEND percpu#for-next] percpu: align percpu readmostly
 subsection to cacheline
Message-ID: <20101228111822.GF488@htj.dyndns.org>
References: <20101227133719.GD488@htj.dyndns.org>
 <20101227204309.GA3878@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101227204309.GA3878@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 27, 2010 at 09:43:09PM +0100, Sam Ravnborg wrote:
> > diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
> > index 003ef4c..173518f 100644
> > --- a/arch/alpha/kernel/vmlinux.lds.S
> > +++ b/arch/alpha/kernel/vmlinux.lds.S
> > @@ -38,7 +38,7 @@ SECTIONS
> >  	__init_begin = ALIGN(PAGE_SIZE);
> >  	INIT_TEXT_SECTION(PAGE_SIZE)
> >  	INIT_DATA_SECTION(16)
> > -	PERCPU(PAGE_SIZE)
> > +	PERCPU(64, PAGE_SIZE)
> >  	/* Align to THREAD_SIZE rather than PAGE_SIZE here so any padding page
> >  	   needed for the THREAD_SIZE aligned init_task gets freed after init */
> >  	. = ALIGN(THREAD_SIZE);
> 
> It would have been better to include cache.h and then use L1_CACHE_BYTES,
> as the value differs for EV4.
> It will work with 64 as this is the bigger of the two.

Hmmm... I took the 64 from RW_DATA_SECTION() macro.  If L1_CACHE_BYTES
is better fit for PERCPU, I'm pretty sure we would be better off with
that for RW_DATA_SECTION() too.  I'll follow up with a patch to change
both to L1_CACHE_BYTES.

> It looks like we could do this for almost all archs.
> But then I am not sure if "L1_CACHE_BYTES" is the same as
> a cacheline on the different archs.

hpa already replied but it seems that different archs have subtle
differences regarding which cacheline size determines what.  If we
want to unify this, it probably would be best to define
INTERNODE_CACHE_BYTES on all archs and use it for all places where
false sharing should be avoided.

Thanks.

-- 
tejun
