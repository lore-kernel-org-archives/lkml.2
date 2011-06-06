Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1FFTua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:50:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:28568 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab1FFTu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:50:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,327,1304319600"; 
   d="scan'208";a="9819218"
From: "Gorby, Russ" <russ.gorby@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ahmed, Suhail" <suhail.ahmed@intel.com>
Subject: RE: [PATCH 1/5] tty: n_gsm: Add raw-ip support
Thread-Topic: [PATCH 1/5] tty: n_gsm: Add raw-ip support
Thread-Index: AQHMJCvh2dGOI7T4jkazdGl++9zespSwlD/Q
Date: Mon, 6 Jun 2011 19:50:26 +0000
Message-ID: <330DDCE36F8D7D47BF87CF587C91A247023257@ORSMSX101.amr.corp.intel.com>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
	<1307127821-21665-2-git-send-email-russ.gorby@intel.com>
 <20110606102854.2f689349@lxorguk.ukuu.org.uk>
In-Reply-To: <20110606102854.2f689349@lxorguk.ukuu.org.uk>
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
>Sent: Monday, June 06, 2011 2:29 AM
>To: Gorby, Russ
>Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org; Ahmed, Suhail
>Subject: Re: [PATCH 1/5] tty: n_gsm: Add raw-ip support
>
>
>> @@ -1590,6 +1616,7 @@ static struct gsm_dlci *gsm_dlci_alloc(struct
>gsm_mux *gsm, int addr)
>>  	dlci->addr = addr;
>>  	dlci->adaption = gsm->adaption;
>>  	dlci->state = DLCI_CLOSED;
>> +	dlci->net = NULL;	/* network not initially created */
>
>kzalloc ised used anyway so this starts NULL
 
[Gorby, Russ] sorry, inherited code - I'll fix it.

>
>>
>> +int gsm_change_mtu(struct net_device *net, int new_mtu)
>> +{
>> +	if ((new_mtu < 8) || (new_mtu > MAX_MTU))
>> +		return -EINVAL;
>> +	net->mtu = new_mtu;
>> +	return 0;
>> +}
>
>Surely at that point you need to renegotiate the DLCI parameters for the
>DLCI in question. At the very least you need to sanity check versus the
>current settings ?

[Gorby, Russ] Thanks, I see we are misusing MAX_MTU, should be gsm->mtu instead

>
>
>> +static int gsm_create_network(struct gsm_dlci *dlci, struct
>gsm_netconfig *nc)
>> +{
>> +	char *netname;
>> +	int retval = 0;
>> +	struct net_device *net;
>> +	struct gsm_mux_net *mux_net;
>> +
>> +	if (!capable(CAP_NET_ADMIN))
>> +		return -EPERM;
>> +
>> +	/* Already in a non tty mode */
>> +	if (dlci->adaption > 2)
>> +		return -EBUSY;
>
>Only you don't have any locking so two ioctls at once will get very
>confused

 [Gorby, Russ] This is an ioctl against a gsmttyN  TTY to turn it into a network IF.
	The same ioctl on different nodes can proceed in parallel w/o problems (that I see). So the exclusion
	you're concerned with is from multiple clients of the TTY issuing this same ioctl at the same time?
	This would indicate a per-dlci exclusion needed then.

>
>
>> +	if (retval) {
>> +		pr_err("network register fail %d\n", retval);
>> +		free_netdev(net);
>> +		goto error_ret;
>
>And this leaves the DLCI messed up

[Gorby, Russ] how so? We don't modify the dlci until after this. We've just copied the mtu at this point.

>
>> +	kref_init(&mux_net->ref);
>
>What stops this getting referenced between the net register and here ?

[Gorby, Russ] OOPs - will fix

>
>On the destroy side you don't seem to put back the old adaption settings
>and restore the state (and also have locking v another ioctl missing)
>
>Doesn't look too hard to fix - save the old dlci states when you go
>network, put them back when you destroy the network state. For the
>ioctls
>you probably need to cover most of each one with the mutex.

 [Gorby, Russ] Thanks for the comments. I appreciate all the help.
