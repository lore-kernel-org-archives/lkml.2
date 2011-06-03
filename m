Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1FCL60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:58:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51180 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1FCL6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=p2Az/rjVWYubZGZWTa2wYWacNx+ZHX8F2jC1YRfVUEq70TAubKYOIKwhs9u4jWZeNI
         qx08Pdjlr0kqZzwhAV9RDpyA5XcK+Gbh+C2Rkf+oCJTONL5eNG787K8Y66miSNncuz0F
         bwPc3TCX11OS62upUA0vUPGPOd7ECRyaniQ/A=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#4
Date: Fri, 3 Jun 2011 13:58:20 +0200
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <20110603013423.GB14872@mtj.dyndns.org> <201106031337.11615.vda.linux@googlemail.com>
In-Reply-To: <201106031337.11615.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106031358.20857.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011 13:37, Denys Vlasenko wrote:
> On Friday 03 June 2011 03:34, Tejun Heo wrote:
> > > This should alleviate Linus' concerns that we are suffering from unnecessary
> > > featuritis - that we invent API which is significantly different
> > > from existing one, and as such users will not use it.
> > > 
> > > Existing API doesn't use GETSIGINFO data per se to distinguish group-stop from
> > > signal-delivery-stop, it uses the fact that GETSIGINFO fails on group-stop.
> > > (Well, arguably it's not a "designed" API, more like "accidentally created API",
> > > but nevertheless it exists right now). Oleg's proposal means that the new way
> > > may be makde to work very similarly.
> > 
> > Okay, you want to preserve %NULL SIGINFO on all STOP traps.  Dropping
> > si_pt_flags and using exit_code makes sense but I think we'll be
> > better off enabling GETSIGINFO.  The affected part of code has to be
> > changed anyway
> 
> Well, not exactly. The affected part of code in strace *has been changed
> already*. Latest version of strace finally does show "SIGSTOP delivered"
> and "group-stop happened" events differently.
> 
> Now strace, ideally, can have a minimal change
> 
> -	ptrace(PTRACE_LISTEN, pid, 0, sig);
> +	if (this_is_group_stop)
> +		ptrace(PTRACE_LISTEN, pid, 0, 0);
> +	else
> +		ptrace(PTRACE_SYSCALL, pid, 0, sig);
> 
> and boom, group-stops are handled correctly!

I meant

-	ptrace(PTRACE_SYSCALL, pid, 0, sig);
+	if (this_is_group_stop)
+		ptrace(PTRACE_LISTEN, pid, 0, 0);
+	else
+		ptrace(PTRACE_SYSCALL, pid, 0, sig);

-- 
vda
