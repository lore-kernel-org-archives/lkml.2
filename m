Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2LEQPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:15:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:48764 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2LEQPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:15:50 -0500
Message-ID: <50BF732C.6030306@linutronix.de>
Date: Wed, 05 Dec 2012 17:15:40 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH RESEND] tty: don't dead lock while flushing workqueue
References: <1353501542-14707-1-git-send-email-bigeasy@linutronix.de>  <20121121140426.1860d093@pyramind.ukuu.org.uk>  <20121127095357.GA3536@breakpoint.cc> <20121127172249.GB24592@kroah.com>  <20121127180108.GA7376@linutronix.de> <1354556465.2531.169.camel@thor>
In-Reply-To: <1354556465.2531.169.camel@thor>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 06:41 PM, Peter Hurley wrote:
> The lock logic for tty_set_ldisc() is wrong. Despite existing code in
> tty_set_ldisc() and tty_ldisc_hangup(), the ldisc_mutex does **not**
> (and should not) play a role in acquiring or releasing ldisc references.
> The only thing that needs to happen here is below (don't actually use
> below because I just hand-edited it):

Hmm. What about I stay in sync with the code that is already in tree
and if the wrong locking gets removed in both places later on?

Alan, what do you prefer?

>> See http://lkml.org/lkml/2012/11/21/347
>>
>>   drivers/tty/tty_ldisc.c |   13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
>> index 0f2a2c5..fb76818 100644
>> --- a/drivers/tty/tty_ldisc.c
>> +++ b/drivers/tty/tty_ldisc.c
>> @@ -930,16 +930,21 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
>>   	 */
>>
>> - 	tty_lock_pair(tty, o_tty);
>>   	tty_ldisc_halt(tty);
>> 	tty_ldisc_flush_works(tty);
>
>
>> +	tty_lock_pair(tty, o_tty);
>>   	/* This will need doing differently if we need to lock */
>>   	tty_ldisc_kill(tty);
>> -
>>   	if (o_tty)
>>   		tty_ldisc_kill(o_tty);
>>

Sebastian
