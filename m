Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab2CSMlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:41:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57442 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2CSMld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:41:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwTZjLHvZLBuNG-aO-+ex_yTYfaqOGqQ+6Krx9Z7EUNQQ@mail.gmail.com>
References: <201203032122.36745.chunkeey@googlemail.com>
	<201203162319.53460.rjw@sisk.pl>
	<201203162325.56303.chunkeey@googlemail.com>
	<201203162357.10770.rjw@sisk.pl>
	<CA+55aFwTZjLHvZLBuNG-aO-+ex_yTYfaqOGqQ+6Krx9Z7EUNQQ@mail.gmail.com>
Date: Mon, 19 Mar 2012 12:41:32 +0000
Message-ID: <CAAMvbhGBW3q8=b93kC2HZC_dCywznebycjYSe_zQtNNt49LbPA@mail.gmail.com>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is
 not yet available
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 March 2012 23:37, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Fri, Mar 16, 2012 at 3:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> +       if (nowait) {
>> +               int limit = loading_timeout * MSEC_PER_SEC;
>> +               int timeout = 10;  /* in msec */
>> +
>> +               while (usermodehelper_is_disabled()) {
>> +                       read_unlock_usermodehelper();
>> +
>> +                       msleep(timeout);
>
> Ugh, this is disgusting.
>
> The whole point of nowait was that it's not synchronous - so it should
> just be driven by timers, not some kind of random "while sleep" loop.
>
> And that fw thing already does have a timeout associated with it, and
> quite frankly, the *sane* approach is to do all this not in
> _request_firmware(), but in request_firmware_work_func() - never even
> call _request_firmware() in the first place if the system isn't ready,
> just reset the timeout to retry it again later.
>
> Seriously. The rule should be really simple: nothing should *ever*
> call "request_firmware()" (or the _request_firmware() helper function)
> while the system is not up. That WARN_ON() should remain totally and
> utterly unconditional, and it should *not* be conditional on "nowait"
> or any idiotic crappy hack like that.
>
> If there is an asynchronous thread - and there is, for the _nowait()
> case - that asynchronous thread should set up the timer and retry in
> ten seconds or whatever. It should *not* call 'request_firmware()" and
> expect that to do something special.
>

Could an alternative be a new event/callback to the driver informing
it that the request_firmware() functionallity is present or not.
The driver would then get a callback on each transition from
"request_firmware() present" to/from "request_firmware() absent".
So, on boot up, the driver ".probe" gets called, and only when enough
infrastructure is up and running does the "request_firmware() present"
callback get called.
The question then becomes
Q1: "how do we determine when enough infrastructure is up for
request_firmware() to succeed?"
Now, if that question can actually be answered, I would prefer that
approach, than to each driver starting a timer based request, to keep
requesting every 2 seconds until it works.

Other similar themes:
could be the driver registers an interest in a particular firmware
file in a particular location, and then when the system determines
that that particular file is now readable, it makes a callback to the
driver. It is certainly an easier question to answer than Q1. No
timers needed.
This could be implemented with a "request_firmware(filename)" that
returns imeadiately but adds the filename to the list of firmware
files to look out for.
The driver then gets a callback "here_is_requested_firmware(filename)"
when the system determines that it can read it.
This list could be scanned immediately and after that; only when a
filesystem is mounted, or the user requests a rescan.

Kind Regards

James
