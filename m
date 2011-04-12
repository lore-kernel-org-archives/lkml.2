Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab1DLT5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:57:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38342 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab1DLT5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:57:38 -0400
Date: Tue, 12 Apr 2011 21:57:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, mstowe@redhat.com,
        dnelson@redhat.com, tony.luck@intel.com, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH]: mce: don't print "human readable" message for
 corrected errors
Message-ID: <20110412195733.GA25123@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
	dzickus@redhat.com, mstowe@redhat.com, dnelson@redhat.com,
	tony.luck@intel.com, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com>
 <20110412185842.GB9891@liondog.tnic>
 <4DA4A68A.2050604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DA4A68A.2050604@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding x86 people.

On Tue, Apr 12, 2011 at 03:22:50PM -0400, Prarit Bhargava wrote:
> 
> 
> On 04/12/2011 02:58 PM, Borislav Petkov wrote:
> > On Tue, Apr 12, 2011 at 01:44:05PM -0400, Prarit Bhargava wrote:
> >   
> >> Don't display the "human readable" warning for correctable errors in mce.
> >> There is no need for this information to be displayed.
> >>
> >> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> >>     
> > Why not? This way you turn reporting of _ALL_ correctable MCEs
> > completely off and some users would actually like to run them through
> > mcelog on Intel.
> >   
> 
> I may be reading the code wrong ... but in the case of the
> default_decode_mce() callback there is *no* additional output displayed
> for correctable MCEs -- so the message is AFAICT useless.
> 
> ie) all you see on the console log is
> 
> [Hardware Error]: Machine check events logged
> 
> ^^^ this notifies the user that something happened with MCE
> 
> [Hardware Error]: No human readable MCE decoding support on this CPU type.
> 
> ^^^ this is purely informational and unnecessary
> 
> [Hardware Error]: Run the message through 'mcelog --ascii' to decode.
> 
> ^^^ this makes absolutely no sense.  There is no message to decode.
> 
> You won't see this in the case of the amd-edac because it has it's own
> callback.

Right, I see what you're sayin'. This is actually this piece:

		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
			mce_log(&m);
			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
			add_taint(TAINT_MACHINE_CHECK);
		}

in machine_check_poll and the reason I added it at the time was so EDAC
gets notified about DRAM ECCs. And you're right, when we're not decoding
in the kernel this message is not helping a lot. I can imagine this
filling up the logs on a machine spitting lotsa DRAM CECC errors.

I'm wondering whether dropping the printks completely is also an option
for I don't see any merit for having them anyway...

Hmmm.

-- 
Regards/Gruss,
    Boris.
