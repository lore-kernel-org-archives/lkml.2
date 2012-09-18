Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab2IRLoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:44:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38642 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab2IRLon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120918093619.GO13767@mwanda>
References: <1347940806-4653-1-git-send-email-navinp@cdac.in>
	<20120918074053.GL4587@mwanda>
	<CAPV97yda9d6yVbTfmET0Rj+xrRDniKzucfKCy=8gUbCDFYR5jg@mail.gmail.com>
	<20120918093619.GO13767@mwanda>
Date: Tue, 18 Sep 2012 17:14:41 +0530
X-Google-Sender-Auth: sDhNUa5YNmaKY12G1cNUi1X5a6g
Message-ID: <CAPV97yfRd_1Ak+DniNyg+vhg1bkOPqzGwRu-LSKXkpW2=_xw+Q@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of usbip_host
From: navin patidar <navinp@cdac.in>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, mfm@muteddisk.com, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for usbip_host  event_handler()   handles following events.  defined
in "usbip_common.h"

 1. SDEV_EVENT_REMOVED   (USBIP_EH_SHUTDOWN | USBIP_EH_RESET | USBIP_EH_BYE)
 2. SDEV_EVENT_DOWN		(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
 3. SDEV_EVENT_ERROR_TCP	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
 4. SDEV_EVENT_ERROR_SUBMIT	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
 5. VDEV_EVENT_ERROR_MALLOC (USBIP_EH_SHUTDOWN | USBIP_EH_UNUSABLE)

In case of events(1,2,3,4),  stub_shoutdown_connection() gets executed
first and than stub_device_reset() .

In case of event 5, stub_shoutdown_connection()  kills kernel threads
and stub_device_unusable()   changes devices status to
"SDEV_ST_ERROR"(fatal error).

 thus stub_device_reset() can't  be called without
stub_shutdown_connection(), so there is no problem of resource leak .
you are also right, i could have set pointers to  NULL in
stub_shutdown_connection() but i used  stub_device_reset() which is
intended to reset usbip_device stuct member variables.

i'll resend patches, if maintainer ask for that.
thanks

--navin-patidar


On Tue, Sep 18, 2012 at 3:06 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Sep 18, 2012 at 03:02:15PM +0530, navin patidar wrote:
>> On Tue, Sep 18, 2012 at 1:10 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > On Tue, Sep 18, 2012 at 09:30:06AM +0530, navin patidar wrote:
>> >> stub_device_reset should set kernel thread pointers to NULL.
>> >> so that at the time of usbip_host removal stub_shoutdown_connection
>> >> doesn't try to kill kernel threads which are already killed.
>> >>
>> >
>> > If you have the Oops output, that's always nice to put in the commit
>> > message.
>>
>> i'll surely keep this in mind  before submitting further patches.
>>
>> > Why don't you set the pointers to NULL in stub_shutdown_connection()
>> > since that's where you actually kill the threads.  Setting them to
>> > NULL in stub_device_reset() will (sometimes) solve the problem but
>> > it gives you a new problem of a resource leak.
>>
>>  stub_device_reset() always gets executed after
>> stub_shutdown_connection() , never before.
>>
>
> No it isn't.  Read event_handler() more carefully.  They can be
> executed independently.
>
> In other words, stub_shutdown_connection() can be called without
> calling stub_device_reset() and stub_device_reset() can be called
> without stub_shutdown_connection().  If either of those happen then
> it causes a problem with the patch you have just sent.
>
> regards,
> dan carpenter
>
