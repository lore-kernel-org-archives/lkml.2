Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946107Ab2CPXiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:38:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41205 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946082Ab2CPXiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <201203162357.10770.rjw@sisk.pl>
References: <201203032122.36745.chunkeey@googlemail.com> <201203162319.53460.rjw@sisk.pl>
 <201203162325.56303.chunkeey@googlemail.com> <201203162357.10770.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Mar 2012 16:37:43 -0700
X-Google-Sender-Auth: bQc1AXR4byYP1gRZ4XvNF_0bgCA
Message-ID: <CA+55aFwTZjLHvZLBuNG-aO-+ex_yTYfaqOGqQ+6Krx9Z7EUNQQ@mail.gmail.com>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is
 not yet available
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 3:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> +       if (nowait) {
> +               int limit = loading_timeout * MSEC_PER_SEC;
> +               int timeout = 10;  /* in msec */
> +
> +               while (usermodehelper_is_disabled()) {
> +                       read_unlock_usermodehelper();
> +
> +                       msleep(timeout);

Ugh, this is disgusting.

The whole point of nowait was that it's not synchronous - so it should
just be driven by timers, not some kind of random "while sleep" loop.

And that fw thing already does have a timeout associated with it, and
quite frankly, the *sane* approach is to do all this not in
_request_firmware(), but in request_firmware_work_func() - never even
call _request_firmware() in the first place if the system isn't ready,
just reset the timeout to retry it again later.

Seriously. The rule should be really simple: nothing should *ever*
call "request_firmware()" (or the _request_firmware() helper function)
while the system is not up. That WARN_ON() should remain totally and
utterly unconditional, and it should *not* be conditional on "nowait"
or any idiotic crappy hack like that.

If there is an asynchronous thread - and there is, for the _nowait()
case - that asynchronous thread should set up the timer and retry in
ten seconds or whatever. It should *not* call 'request_firmware()" and
expect that to do something special.

                    Linus
