Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1EKTYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:24:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48352 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab1EKTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QpkwjqR5aqdOq75P0ZywcihqZvqiuv5z2/XLT9VliD52XRJQaO5bAI1OyEpezYfdlK
         4v28HURu8p+8pbls+IvCp2hxIqv9G/vsI4GPHkCvr+m7+tEDycSOvtnGx6Nzol2RBXEp
         xssNx+LtQ2ufhztNgaDHbZg1qAMLr4NyLXS/8=
Date: Wed, 11 May 2011 21:24:20 +0200
From: Tejun Heo <tj@kernel.org>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110511192420.GB24245@mtj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com>
 <20110511091955.GD1661@htj.dyndns.org>
 <BANLkTikQm1PVCW3164g0bfgU9fs4MMTfNA@mail.gmail.com>
 <20110511132218.GG1661@htj.dyndns.org>
 <BANLkTi=mm_rUXcH4Ufq_GdMLnpz4N7B_vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=mm_rUXcH4Ufq_GdMLnpz4N7B_vg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 11, 2011 at 12:20:11PM -0400, Bryan Donlan wrote:
> If a process issues PTRACE_INTERRUPT, it just wants the target process
> to stop. Presumably it doesn't really care _why_, as long as it
> doesn't introduce spurious effects visible to the target. As such, if
> the process stops on its own due to some other trap, that ought to be
> good enough, right? Is there really a need for a trap that will be
> reliably echoed back to the trapping process?

It can go either way.  I just chose one.  One use case which made me
favor not clearing INTERRUPT on other traps was that INTERRUPT, along
with group stop trap, is special in that it allows notification
re-traps.  It serves as per-tracee job control trap site which
debugger can use as it pleases.

As such, there are times where debugger wants to put tracee into that
specific trap.  If INTERRUPT gets cleared on every trap, it would have
to set INTERRUPT on each trap until it reaches INTERRUPT trap which
seemed kinda silly and given that INTERRUPT may happen for spurious
notification reasons, there didn't seem much point in avoiding the
trap because there was another trap.

That said, as it makes INTERRUPT behavior different from SEIZE and I
think occassional multiple traps on SEIZE could be uglier.  I think
I'll change it such that it clears on any trap.  If debugger wants to
put tracee specifically into INTERRUPT trap, it will have to raise it
after each unsuccessful trap.  It would be annoying but I suppose it's
lesser of the two evils.

Thanks.

-- 
tejun
