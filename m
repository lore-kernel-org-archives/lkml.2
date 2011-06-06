Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1FFRJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:09:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:4708 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab1FFRJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,327,1304319600"; 
   d="scan'208";a="7933107"
From: "Gorby, Russ" <russ.gorby@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ahmed, Suhail" <suhail.ahmed@intel.com>
Subject: RE: [PATCH 4/5] tty: n_gsm: initiate close of all DLCIs during mux
 shutdown
Thread-Topic: [PATCH 4/5] tty: n_gsm: initiate close of all DLCIs during mux
 shutdown
Thread-Index: AQHMIjoPAB/bGYdY3Uq1UIRRprDnsZSwj8iw
Date: Mon, 6 Jun 2011 17:09:37 +0000
Message-ID: <330DDCE36F8D7D47BF87CF587C91A247023149@ORSMSX101.amr.corp.intel.com>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
	<1307127821-21665-5-git-send-email-russ.gorby@intel.com>
 <20110603230514.334df229@lxorguk.ukuu.org.uk>
In-Reply-To: <20110603230514.334df229@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.131.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>Sent: Friday, June 03, 2011 3:05 PM
>To: Gorby, Russ
>Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org; Ahmed, Suhail
>Subject: Re: [PATCH 4/5] tty: n_gsm: initiate close of all DLCIs during
>mux shutdown
>
>On Fri,  3 Jun 2011 12:03:40 -0700
>Russ Gorby <russ.gorby@intel.com> wrote:
>
>> Although DLCI-0 is closed during ldisc close, we found the
>> applications were better served when open DLCI shutdowns where
>> initiated at that time as well.
>
>They should all see a hangup on the gsm client tty anyway ?
>
>> -	for (i = 0; i < NUM_DLCI; i++)
>> +	for (i = NUM_DLCI-1; i >= 0; i--) {
>> +		dlci = gsm->dlci[i];
>> +		if (dlci) {
>> +			if (i != 0)
>> +				gsm_dlci_begin_close(dlci);
>> +			else {
>> +				dlci->dead = 1;
>> +				gsm_dlci_begin_close(dlci);
>> +				t = wait_event_timeout(gsm->event,
>> +					   dlci->state == DLCI_CLOSED,
>> +					   gsm->t2 * HZ / 100);
>> +				if (!t) {
>> +					pr_info("%s: timeout dlci0 close",
>> +						__func__);
>> +					gsm_dlci_close(dlci);
>> +				}
>> +			}
>> +		}
>> +	}
>> +	for (i = NUM_DLCI-1; i >= 0; i--)
>
>I'd like to understand better why it is needed and also why you don't
>want for the others to close but just set it off ?

[Gorby, Russ] I suppose it is possible the issue this code helped alleviate was due to modem firmware or
Other s/w bugs or timing issues, but since we're waiting for DLCI0 to close it made sense to at least start the
Close of the other channels first. If you don't want to take this patch at this point, I can revalidate if it is needed
at a later time and resubmit then if so.
