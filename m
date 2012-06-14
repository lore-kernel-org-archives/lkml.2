Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2FNNyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:54:09 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44166 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756218Ab2FNNyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:54:04 -0400
X-Sasl-enc: NyYvObB+dgLmlYpKkfRKU1Q/ql//NJMX+AFaxjabqeyw 1339682043
Date: Thu, 14 Jun 2012 10:54:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] x86: Do microcode updates at CPU_STARTING, not
 CPU_ONLINE
Message-ID: <20120614135401.GA24491@khazad-dum.debian.net>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
 <1339618842-26636-2-git-send-email-andi@firstfloor.org>
 <20120614110049.GA13629@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614110049.GA13629@x1.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Borislav Petkov wrote:
> On Wed, Jun 13, 2012 at 01:20:39PM -0700, Andi Kleen wrote:
> >  	case CPU_ONLINE:
> >  	case CPU_ONLINE_FROZEN:
> > -		microcode_update_cpu(cpu);
> > +		/* Retry again in case we couldn't request early */
> > +		if (cpu_data(cpu).microcode < ucode_cpu_info[cpu].cpu_sig.rev)
> > +			microcode_update_cpu_late(cpu);
> 
> This implies newer ucode versions are numerically higher than
> what's currently present. And it is probably correct in the 99% of
> the cases but it would be more correct IMHO to have "!=" there.
> microcode_update_cpu_late takes care of checking the correct ucode
> version anyway down the path.

Indeed.  For Intel, the microcode rev is a *signed* value, and the
intended way for it to work is that you always install negative rev
microcode (used only internally at Intel, I am told), or install
microcode if rev(new microcode) > rev (old microcode) >= 0, and refuse
to install if rev(new microcode) == 0.

It is better to use != and have stricter checks in the vendor-specific
code.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
