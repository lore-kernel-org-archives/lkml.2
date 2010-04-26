Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab0DZKjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 06:39:07 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33644 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab0DZKjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 06:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com> 
	<20100419145934.GA10893@kroah.com> <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com> 
	<20100425163711.GA20196@kroah.com> <o2n1ba2fa241004251222x6ab49726p9757fd8be4952bee@mail.gmail.com> 
	<20100425193658.GA24039@kroah.com> <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 26 Apr 2010 12:38:47 +0200
Message-ID: <o2qac3eb2511004260338xd8146a7dy415d3f0f4f1c8bbc@mail.gmail.com>
Subject: Re: request_firmware API exhaust memory
To: Tomas Winkler <tomasw@gmail.com>
Cc: Greg KH <greg@kroah.com>, Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 22:09, Tomas Winkler <tomasw@gmail.com> wrote:
> Said thing is that I don't see where the memory goes.... Anyhow I will
> try to run valgrin on udev just to be sure.

Nah, that memory would be freed, if you kill all udev processes, which
it doesn't.

The many udev worker processes you see for a few seconds was caused by
udevd handling events with TIMEOUT= set special. We need to make sure,
that firmware events run immediately and don't wait for other
processes to finish. The logic who does that was always creating a new
worker. I changed this now, but this will not affect the underlying
problem you are seeing, it will just make the udev workers not grow in
a timeframe of less than 10 seconds. The change is here:
  http://git.kernel.org/?p=linux/hotplug/udev.git;a=commit;h=665ee17def2caa6811ae032ae68ebf8239a18cf8
but as mentioned, this change is unrelated to the memory leak you are seeing.

> I'll be glad If someone can run my simple driver I posted and confirm
> that sees the same problem

I can confirm that memory gets lost. I suspect for some reason the
firmware does not get properly cleaned up. If you increase the size of
the firmware image, it will leak memory much faster.

Kay
