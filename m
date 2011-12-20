Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1LTDJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:09:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1LTDJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:09:05 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5Kkf9dAxP3YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=zAyngx5bAAAA:8 a=eYQAo4VducCI_R2k2g0A:9 a=PUjeQqilurYA:10 a=9g6PTisfegMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324350542.5916.48.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] recordmcount: Fix handling of elf64 big-endian objects.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Date: Mon, 19 Dec 2011 22:09:02 -0500
In-Reply-To: <1324345362-12230-1-git-send-email-ddaney.cavm@gmail.com>
References: <1324345362-12230-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 17:42 -0800, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> In ELF64, the sh_flags field is 64-bits wide.  recordmcount was
> erroneously treating it as a 32-bit wide field.  For little endian
> objects this works because the flags of interest (SHF_EXECINSTR)
> reside in the lower 32 bits of the word, and you get the same result
> with either a 32-bit or 64-bit read.  Big endian objects on the
> other hand do not work at all with this error.
> 
> The fix:  Correctly treat sh_flags as 64-bits wide in elf64 objects.
> 
> The symptom I observed was that my
> __start_mcount_loc..__stop_mcount_loc was empty even though ftrace
> function tracing was enabled.
> 

OUCH!

This looks like something that needs to go to stable. Let me play with
this on my PPC64 tomorrow.

Thanks!

-- Steve

> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  scripts/recordmcount.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
> index f40a6af6..54e35c1 100644
> --- a/scripts/recordmcount.h
> +++ b/scripts/recordmcount.h
> @@ -462,7 +462,7 @@ __has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
>  		succeed_file();
>  	}
>  	if (w(txthdr->sh_type) != SHT_PROGBITS ||
> -	    !(w(txthdr->sh_flags) & SHF_EXECINSTR))
> +	    !(_w(txthdr->sh_flags) & SHF_EXECINSTR))
>  		return NULL;
>  	return txtname;
>  }


