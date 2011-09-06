Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1IFRUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:20:49 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:40516 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1IFRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:20:45 -0400
Message-id: <4E665653.7070807@acm.org>
Date: Tue, 06 Sep 2011 12:20:19 -0500
From: Corey Minyard <minyard@acm.org>
Reply-to: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21)
 Gecko/20110831 Thunderbird/3.1.13
MIME-version: 1.0
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        Jason Wessel <jason.wessel@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [V3][PATCH 3/6] x86, nmi: wire up NMI handlers to new routines
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314290748-23569-4-git-send-email-dzickus@redhat.com>
In-reply-to: <1314290748-23569-4-git-send-email-dzickus@redhat.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 11:45 AM, Don Zickus wrote:
> diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
> index 3302586..3dcab56 100644
> --- a/drivers/char/ipmi/ipmi_watchdog.c
> +++ b/drivers/char/ipmi/ipmi_watchdog.c
> @@ -1077,17 +1077,8 @@ static void ipmi_unregister_watchdog(int ipmi_intf)
>
>   #ifdef HAVE_DIE_NMI
>   static int
> -ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
> +ipmi_nmi(unsigned int val, struct pt_regs *regs)
>   {
> -	struct die_args *args = data;
> -
> -	if (val != DIE_NMIUNKNOWN)
> -		return NOTIFY_OK;
> -
> -	/* Hack, if it's a memory or I/O error, ignore it. */
> -	if (args->err&  0xc0)
> -		return NOTIFY_OK;
> -
>   	/*
>   	 * If we get here, it's an NMI that's not a memory or I/O
>   	 * error.  We can't truly tell if it's from IPMI or not
 From the comment above, this will not actually work for the IPMI 
watchdog.  The only way to tell if an NMI is from the IPMI controller is 
to send a message to the IPMI controller and wait for the response.  Not 
an option in an NMI handler.  So the IPMI watchdog driver relied on it 
being last, and if nothing else handled the NMI, then it must have been 
from the IPMI controller.

This is stupid, I know, but that's the way it works in IPMI.  If we 
decide to do what you are suggesting we will have to disable this 
function in the IPMI watchdog driver or we need some way to say "if 
nothing else handled the NMI, call this."

-corey

