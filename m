Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0IUE0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:26:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47214 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab0IUE0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G7Yxf7778zMBTFx+3t2zqc7zrycR7HJ8+WqOE49NRtMrL827gNrHI1bXeZD9clNQXr
         uNl0knasIDqvo1PK0FTMtT4xwstv2gY/92IdA33iyJdnqvA5KRASuHVXm8QOBRAuA8LX
         MPDh4tx35RwxHwGkrWTTddtE4KVlSM7Sr77S4=
MIME-Version: 1.0
In-Reply-To: <1285023750.30856.99.camel@morgan.silverblock.net>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	<AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	<1285023750.30856.99.camel@morgan.silverblock.net>
Date: Tue, 21 Sep 2010 00:26:29 -0400
Message-ID: <AANLkTi=RCJcQMSWMm6pQgJnJZT9TyfGyFtWmeu8GKHA-@mail.gmail.com>
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS polling
From: Alex Deucher <alexdeucher@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Jon Smirl <jonsmirl@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/20 Andy Walls <awalls@md.metrocast.net>:
> On Mon, 2010-09-20 at 20:29 +0200, Rafał Miłecki wrote:
>> 2010/9/20 Andy Walls <awalls@md.metrocast.net>:
>> > DRM KMS polling of connections providing errant EDID responses, or
>> > polling of "connectors" that have chips responding on DDC I2C bus
>> > address 0xA0/0xA1 with no actual physical connector nor EDID EEPROM,
>> > will create perpetual noise in dmesg and the system log every 10
>> > seconds.  Currently the user has apparently little recourse to silence
>> > these messages aside from replacing the offending cable, monitor, or
>> > graphics adapter.  That recourse is impossible for an unused DVI-D
>> > "connector" of an internal graphics processor on a motherboard that
>> > provides no physical DVI-D connector.
>> >
>> > This change allows the root user to disable (and re-enable) DRM KMS
>> > connector polling on a per connector basis via sysfs, like so:
>>
>> Huh, I didn't imagine solution of this issue that way.
>
> The problems with my initial patch, and related approaches, were:
>
> 1. They didn't get rid of all the spam in the logs, just the most
> verbose portion of it.
>
> 2. They didn't deal with the root cause of the log spam and all the
> related, but unneeded, I/O and processing that was still occurring.
>
>
>
>>  AFAIR previous
>> thread, something else was suggested, it was about storing the fact
>> that user already received warning/info about error.
>
> Yes, that was the discussion.
>
> I went with this patch because:
>
> 1. It deals with the root cause: unneeded DRM KMS connector polling
>
> 2. It eliminates all my DRM KMS connector polling related log spam, not
> just the hex dump.
>
> 3. The existing sysfs structure was already exposing 'struct
> drm_connector' members to user-space at per connector granularity
>
>
> The real root cause of the polling spew is that the radeon module, based
> on the best information it has (BIOS connector tables, I2C bus probes,
> etc.), makes a decision on if a connector should be polled and how it
> should be polled.
>
> Given incorrect BIOS tables, and strange I2C setups, the radeon module
> is bound to make the wrong decision about polling in some cases.  This
> change is a way for the human to step in a correct things, when the
> radeon driver gets it wrong.
>

I'd rather fix the bug for real rather than providing users with an
out so that the bug never gets reported.  What's the actual problem
you have?  Do you just want to turn polling off for an unused
connecter, or does the board have a bug in the connector table?  If
it's a bug, we can add a quirk so that it's properly handled.  What
physical connectors does the board have what does the driver report in
dmesg?

Alex

> In my case, along with the log spam, there are also a lot of unneeded
> I2C transactions going on.
>
>
> BTW, I found that Chris Wilson recently committed a change to inhibit
> all drm connector polling globally for a different reason:
>
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commit;h=e58f637bb96d5a0ae0919b9998b891d1ba7e47c9
>
> That commit message shows a case where the driver decides polling needs
> to happen, but the human knows differently and manual control over
> connector polling mitigates the problem.
>
>
>
>
>
>> Why I don't really like proposed solution?
>> 1) You need to be root
>
> Yes, for both sysfs and module parameters.
>
> I view video hardware configuration (montiors, cables, graphics cards)
> and control of what gets logged into files as system administrative
> issues.  I'd assume that needing root privileges to turn on and off
> device auto detection would be the norm.  I imagined that root would set
> up any DRM KMS connector polling fixes once in an init script and be
> done with it.  Is there any other use-case you had in mind?
>
> If there's some set-uid or group privilege method or utilities that's in
> common use (xrandr?) for manual control of drm/kms parameters, that you
> think would be better, just point me in that direction and I'll try to
> work something out.
>
> However, trying to code automatic control of when to disable DRM KMS
> connector polling, by some heuristic or algorithm in radeon or drm, is
> likely doomed to failure for corner cases or for someone's policy
> preferences.  I'd rather not attempt that.
>
>
>> 2) Need to know and play with some "magic" sysfs file.
>
> I strongly dislike ever using sysfs myself.  However, I'll spare us all
> my rantings^Wreasons. ;)
>
> My problem with KMS was with the documentation I could find.  The
> "userland interfaces" section in Documentation/Docbook/drm.tmpl is
> essentially empty.  DRM design documents at freedesktop.org (which
> actually look closer to requirements documents) are the most detailed
> documents I could find, but they don't really cover KMS.  Maybe I'm just
> looking in the wrong places.
>
> Is there a KMS or DRM_MODESET API document?  Maybe I could propose a new
> ioctl(), if there isn't already one that will be usable for controlling
> DRM KMS polling.
>
>
>
>> I thing it would be much better and user-friendly to display such an
>> error just once per display. How this could be implemented?
>>
>> 1) Add field like "warned" to connector struct, default to 0
>> 2) if (warning_to_be_printed && !connector->warned) { printk();
>> connector->warned = 1
>> 3) if (connector_disconnected) { connector->warned = 0; }
>>
>> This was you will get just one warning per connected display. Of
>> course after disconnecting it we have to clear "warned", as user may
>> connect another "broken" display, then we should print warning again.
>>
>> What do think about this solution?
>
> I followed most of the function calls back and looked at he return
> values and error messages that can get emitted under various
> circumstances.  The amount of effort and complexity for trying to
> supress all the error messages due to the 10 second poll just wasn't
> worth it, when supressing the polling was so much easier.  For
> supressing error messages, I decided there was too much state to track
> and that any policy I hard-coded would be wrong for someone.
>
> >From inside the code, it is difficult to decide what message about
> errors induced from the external environment are important to the user
> and what aren't.  It's too dependent on the external context and what
> action the user would like to take under various conditions.
>
>
> Thanks for your comments.  Sorry for the long reply.
>
> Regards,
> Andy
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
