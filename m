Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1FCLhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:37:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42667 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1FCLhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=OaKSGT9pf+uQdUZY5+KD5566TofVfKdyJ7zQDll3oBYTkdiMe6x5mXEPg7SjzbNpM5
         BmOZby+CzbQ/VVVTarinW0bGncq2ufP3kIho+UJGNp3rKOtLN2bdNG8bRt+DOH+JIZ+J
         o8Iz8BwIIRRJOZzs+MqrsH2vqrd8wh7V2UbpU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#4
Date: Fri, 3 Jun 2011 13:37:11 +0200
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <201106022309.44663.vda.linux@googlemail.com> <20110603013423.GB14872@mtj.dyndns.org>
In-Reply-To: <20110603013423.GB14872@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106031337.11615.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011 03:34, Tejun Heo wrote:
> > This should alleviate Linus' concerns that we are suffering from unnecessary
> > featuritis - that we invent API which is significantly different
> > from existing one, and as such users will not use it.
> > 
> > Existing API doesn't use GETSIGINFO data per se to distinguish group-stop from
> > signal-delivery-stop, it uses the fact that GETSIGINFO fails on group-stop.
> > (Well, arguably it's not a "designed" API, more like "accidentally created API",
> > but nevertheless it exists right now). Oleg's proposal means that the new way
> > may be makde to work very similarly.
> 
> Okay, you want to preserve %NULL SIGINFO on all STOP traps.  Dropping
> si_pt_flags and using exit_code makes sense but I think we'll be
> better off enabling GETSIGINFO.  The affected part of code has to be
> changed anyway

Well, not exactly. The affected part of code in strace *has been changed
already*. Latest version of strace finally does show "SIGSTOP delivered"
and "group-stop happened" events differently.

Now strace, ideally, can have a minimal change

-	ptrace(PTRACE_LISTEN, pid, 0, sig);
+	if (this_is_group_stop)
+		ptrace(PTRACE_LISTEN, pid, 0, 0);
+	else
+		ptrace(PTRACE_SYSCALL, pid, 0, sig);

and boom, group-stops are handled correctly!

> and with %NULL GETSIGINFO we effectively would have 
> driven ourselves into corner if more information needs to be added
> later on.

Oleg thinks that GETSIGINFO may be not the best way to provide additional data.
Think about it. It's "get _signal_ info" op. By overloading it to mean something
else, we are creating yet another ptrace quirk: "sometimes GETSIGINFO will
return something else than signal info".

Oleg says he prefers to add a separate GETfoo op, with cleaner meaning.


> Don't current users unconditionally issue CONT(sig) anyway? 

Yes.

-- 
vda
