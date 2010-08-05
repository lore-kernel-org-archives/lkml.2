Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab0HESUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:20:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43850 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab0HESUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:20:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=th9cASePRD9EeGLdEBbardqvtoDkzrZW74rfKX0qpLDHI6GhHQt2eDAE/AcE8i1Iq
	M+yERWuPiMlsY6h5M2S5Q==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
References: <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com>
	<alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm>
	<AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com>
	<alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
	<20100804233013.GN24163@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm>
	<20100805001716.GO24163@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm>
	<20100805004802.GP24163@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm>
	<20100805151211.GA10080@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm>
	<AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
Date: Thu, 5 Aug 2010 11:20:46 -0700
Message-ID: <AANLkTinTBaJ7Re8E4DVmZcDAUsceUf+9jV7r67Ks=t2n@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Brian Swetland <swetland@google.com>
To: kevin granade <kevin.granade@gmail.com>
Cc: david@lang.hm, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 11:13 AM, kevin granade <kevin.granade@gmail.com> wrote:
> IIRC, this was a major point of their (Android's) power management
> policy.  User input of any kind would reset the "display active"
> timeout, which is the primary thing keeping random untrusted
> user-facing programs from being suspended while in use.  They seemed
> to consider this to be a special case in their policy, but from the
> kernel's point of view it is just another suspend blocker being held.

The display being on should not prevent suspend unless the particular
platform is incapable of suspending while the display is on.

> I'm not sure this is the best use case to look at though, because
> since it is user-facing, the timeout durations are on a different
> scale than the ones they are really worried about.  I think another
> category of use case that they are worried about is:
>
> (in suspend) -> wakeup due to network -> process network activity -> suspend
>
> or an example that has been mentioned previously:
>
> (in suspend) -> wakeup due to alarm for audio processing -> process
> batch of audio -> suspend
>
> In both of these cases, the display may never power on (phone might
> beep to indicate txt message or email, audio just keeps playing), so
> the magnitude of the "timeout" for suspending again should be very
> small.  Specifically, they don't want there to be a timeout at all, so
> as little time as possible time is spent out of suspend in addition to
> the time required to handle the event that caused wakeup.

Yeah, we much prefer the wakelock model where the moment the resource
(system-needing-to-not-be-suspended) is released we return to the
lowest power state, rather than waiting for a timer to expire (and/or
burning cycles polling for "can we suspend yet?" when we're definitely
not ready to suspend).

Brian
