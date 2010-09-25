Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab0IYWhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 18:37:53 -0400
Received: from tuxonice.net ([74.207.252.127]:52702 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab0IYWhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 18:37:52 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C9E79BD.4030003@tuxonice.net>
Date: Sun, 26 Sep 2010 08:37:49 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] [linux-pm] [PATCH] Hibernate:  Implement readahead
 when resuming
References: <1285416056-9735-1-git-send-email-nigel@tuxonice.net> <201009252158.28439.Martin@lichtvoll.de> <4C9E68A9.6090603@tuxonice.net> (sfid-20100925_235951_865640_006D16F6) <201009260011.04070.Martin@lichtvoll.de>
In-Reply-To: <201009260011.04070.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 26/09/10 08:10, Martin Steigerwald wrote:
> Hi Nigel.
>
> Am Samstag 25 September 2010 schrieb Nigel Cunningham:
>> On 26/09/10 05:58, Martin Steigerwald wrote:
>>> Am Samstag 25 September 2010 schrieb Martin Steigerwald:
>>>> Hi Nigel and Rafael,
>>>>
>>>> Am Samstag 25 September 2010 schrieb Nigel Cunningham:
>>>>> Add support for submitting reads before they're needed. This
>>>>> greatly improves the speed of resuming:
>>>>>
>>>>> From
>>>>>
>>>>> PM: Image read at 66 MB/s.
>>>>>
>>>>> to
>>>>>
>>>>> PM: Image read at 229 MB/s.
>>>>>
>>>>> ...and removes the need for the sync_read flag.
>>>>
>>>> So
>>>>
>>>> martin@shambhala:~/Computer/Shambhala/Kernel/2.6.36/tuxonice-head>
>>>> git branch -av | grep for-rafael
>>>> * for-rafael                      d4e7490 Hibernate: Implement
>>>> readahead when resuming
>>>>
>>>>     remotes/origin/for-rafael       d4e7490 Hibernate: Implement
>>>>
>>>> readahead when resuming
>>>
>>> [...]
>>>
>>>> basically seems to work.
>>>
>>> [...]
>>>
>>>> I tried 5 times:
>>>>
>>>> - one with just kdm started worked nicely and really rather fast!
>>>>
>>>> - four with a full blown KDE 4.5.1 session with OpenGL compositing
>>>>
>>>>     - one seemed to hang prior to reinitializing the Radeon KMS DRM
>>>>     setup - three other worked just fine
>>>>
>>>> I do not think that the hang is related to your changes, Nigel. The
>>>> kernel remained stuck at the lower initial resolution and didn't
>>>> seem to initialize the radeon KMS framebuffers at 1400x1050
>>>> properly. I didn't see this with 2.6.35 and userspace software
>>>> suspend.
>>>
>>> I am not so sure anymore.
>>>
>>> I got another one of these hangs with the 2.6.36-rc5 mentioned above.
>>> See IMG_3871.jpg for the exact display were it hung. I was able to
>>> switch view with Alt-F1 or something like that. And then got
>>> IMG_3873.jpg. But nothing happened anymore. Find these on:
>>>
>>> http://martin-steigerwald.de/tmp/tuxonice/hang-after-resume-with-pm-
>>> patches-for-rafael/
>>>
>>> I now tried in kernel suspend to disk with
>>>
>>> martin@shambhala:~>   cat /proc/version
>>> Linux version 2.6.35.5-tp42-vmembase-0-pm-avoid-oom-dirty
>>> (martin@shambhala) (gcc version 4.4.5 20100728 (prerelease) (Debian
>>> 4.4.4-8) ) #4 PREEMPT Sat Sep 25 13:29:53 CEST 2010
>>>
>>> which doesn't contain your patches, Nigel, for about 5 or 6 times and
>>> I did not see that hang.
>>>
>>> So maybe something in your patches, even if just the debug output I
>>> mentioned, or something in 2.6.36-rc5 triggers that hang.
>>>
>>> I will test 2.6.35.5 for a bit longer to make sure that there is no
>>> hang on resume prior to loading. I need to reboot this one now too,
>>> cause after one of the resume attempts USB stopped working with:
>>>
>>> Sep 25 21:36:47 shambhala kernel: usb 1-3: New USB device found,
>>> idVendor=1307, idProduct=0330
>>> Sep 25 21:36:47 shambhala kernel: usb 1-3: New USB device strings:
>>> Mfr=1, Product=2, SerialNumber=3
>>> Sep 25 21:36:47 shambhala kernel: usb 1-3: Product: Mass Storage
>>> Device Sep 25 21:36:47 shambhala kernel: usb 1-3: Manufacturer:
>>> Generic Sep 25 21:36:47 shambhala kernel: usb 1-3: SerialNumber:
>>> 00000000000006 Sep 25 21:36:47 shambhala kernel: scsi3 : usb-storage
>>> 1-3:1.0 Sep 25 21:36:48 shambhala kernel: BUG: unable to handle
>>> kernel NULL pointer dereference at 0000002c
>>> Sep 25 21:36:48 shambhala kernel: IP: [<c125b5de>]
>>> cfq_get_queue+0x33e/0x550
>>> Sep 25 21:36:48 shambhala kernel: *pde = 00000000
>>> Sep 25 21:36:48 shambhala kernel: Oops: 0000 [#1] PREEMPT
> [...]
>>> exited with preempt_count 1
>>>
>>> Maybe the USB system has an powermanagement related issue that in
>>> kernel suspend triggers more easily than userspace software suspend?
>>> I didn't see this one before. But well, this is a bug I will report
>>> in
>>> bugzilla.kernel.org.
>>>
>>> Ciao,
>>
>> Okay. Can you try without the last patch, and confirm that it's
>> reliable (albeit slower) then?
>
> Well as I told already (later on) the USB problem seems to be related to
> my testing of systemd in Debian - I do not get how this could be the case,
> but it works, when I remove init=/bin/systemd. I think I will report this
> as a kernel bug nonetheless, cause when I apply that "userspace shouldn't
> be able to let the kernel oops" paradigm then its a kernel bug.
>
> Should I test without the readahead patch regarding whether that hang
> after resume, prior to activating Radeon KMS framebuffer is fixed as well?

Yes, please. I only whipped up the readahead patch last night. Since 
it's single threaded, there's a lot less to go wrong compared to 
TuxOnIce, but it's still possible that there's some bug I haven't 
noticed yet. It would be good to be able to see it's definitely that patch.

> I am a bit unsure on what to test next. My current thoughts are:
>
> - Test whether 2.6.35.5 is stable with unpatched in kernel suspend.
> Currently in progress. Cause before that I only know its stable with
> userspace software suspend.
>
> - Apply your patches on top of 2.6.35.5 and test that.
>    - If that works, it appears to be a problem introduced by 2.6.36-rc5
>      - Then I'd possibly test 2.6.36-rc5 with unpatched in kernel suspend.
>    - If that doesn't work, it appears to be an issue with your patches
>      - Then I test without readahead patch.
>
> Tell me when you have any different suggestions.
>
> Ciao,

I'd start with 2.6.36-rc5 unpatched, and only fall back to 2.6.35 if 
that's unreliable.

Regards,

Nigel
