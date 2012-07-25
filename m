Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab2GYNyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:54:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33306 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927Ab2GYNyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaOTvF=e3j8ypzK8_V5Uh_8Nk1U74uVe4tcXs+cdQvimjg@mail.gmail.com>
References: <1343141382-31087-1-git-send-email-benchan@chromium.org> <CAHdPZaOTvF=e3j8ypzK8_V5Uh_8Nk1U74uVe4tcXs+cdQvimjg@mail.gmail.com>
From: Ben Chan <benchan@chromium.org>
Date: Wed, 25 Jul 2012 06:53:55 -0700
X-Google-Sender-Auth: OdyGkyccCC9-GlC76Hm6Td00T_s
Message-ID: <CAC5Y2nMeYvKhMjPFFa-3tGLOOyxXX1B8MZSbXrMLsNDPJmdmzA@mail.gmail.com>
Subject: Re: [PATCH v2] staging: gdm72xx: fix reference counting in gdm_wimax_event_init
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devendra,

Thanks for cleaning up the driver.  If I understand the code
correctly, the original author wanted to initialize wm_event once and
reuse it for multiple devices, and thus reference counted it with
ref_cnt.

For instance, each time gdm_usb_probe() is called, it may call
register_wimax_device() / gdm_wimax_event_init(). wm_event is
initialized the first time when wm_event.ref_cnt == 0 (alternatively,
the code could check !wm_event.sock). Subsequent calls to
gdm_wimax_event_init() will simply increase the ref count. Similarly,
gdm_usb_disconnect() calls unregister_wimax_device() /
gdm_wimax_event_exit(), which decreases the ref count and disposes
wm_event when ref_cnt becomes zero.

The code change in commit 8df858ea76b76dde9a39d4edd9aaded983582cfe
only prevents ref_cnt from increasing beyond one. So the code no
longer work when there are multiple devices (i.e. wm_event could be
disposed even when there is an active device).

Thanks,
Ben


On Tue, Jul 24, 2012 at 9:50 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
> On Tue, Jul 24, 2012 at 8:34 PM, Ben Chan <benchan@chromium.org> wrote:
>> This patch fixes the commit "staging/gdm72xx: cleanup little at
>> gdm_wimax_event_rcv" (8df858ea76b76dde9a39d4edd9aaded983582cfe),
>> which mishandles the reference counting of wm_event.
>>
>> Signed-off-by: Ben Chan <benchan@chromium.org>
>> ---
>> Fixed the commit message as suggested by Dan Carpenter.
>>
>>  drivers/staging/gdm72xx/gdm_wimax.c |   16 ++++++++++------
>>  1 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
>> index 0716efc..6cb8107 100644
>> --- a/drivers/staging/gdm72xx/gdm_wimax.c
>> +++ b/drivers/staging/gdm72xx/gdm_wimax.c
>> @@ -258,12 +258,16 @@ static int gdm_wimax_event_init(void)
>>         if (!wm_event.ref_cnt) {
>>                 wm_event.sock = netlink_init(NETLINK_WIMAX,
>>                                                 gdm_wimax_event_rcv);
>> -               if (wm_event.sock)
>> -                       wm_event.ref_cnt++;
>> -               INIT_LIST_HEAD(&wm_event.evtq);
>> -               INIT_LIST_HEAD(&wm_event.freeq);
>> -               INIT_WORK(&wm_event.ws, __gdm_wimax_event_send);
>> -               spin_lock_init(&wm_event.evt_lock);
>> +               if (wm_event.sock) {
>> +                       INIT_LIST_HEAD(&wm_event.evtq);
>> +                       INIT_LIST_HEAD(&wm_event.freeq);
>> +                       INIT_WORK(&wm_event.ws, __gdm_wimax_event_send);
>> +                       spin_lock_init(&wm_event.evt_lock);
>> +               }
>> +       }
>> +
>> +       if (wm_event.sock) {
>> +               wm_event.ref_cnt++;
>>                 return 0;
>>         }
>>
>> --
>> 1.7.7.3
>>
>
> Hi Ben,
>
> I have some basic understanding about this flow of the function,
>
> Here is my understanding of the thing i have done when i was doing
> some cleanups to this driver.
>
> The ref_cnt will be 0 at first time. if so the sock creation happens
> only once, and register_wimax_device only calls this function.
> so i think doing the ref_cnt++ inside the if (!wm_event.ref_cnt) is valid.
>
> Please suggest me if i am wrong.
>
> Thanks,
