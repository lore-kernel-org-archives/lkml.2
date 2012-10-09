Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2JILYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 07:24:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33471 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2JILX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 07:23:57 -0400
MIME-Version: 1.0
X-Originating-IP: [116.14.92.167]
In-Reply-To: <s5hr4p8ez6u.wl%tiwai@suse.de>
References: <CAMVG2st1-3kz-KRrm-zXZOGw8=QnyYbB3n5e8Z36xAbmD4b5RQ@mail.gmail.com>
	<s5hvceli0ht.wl%tiwai@suse.de>
	<CAMVG2ss7hmJAEt-vEsNBmTVDWMYCPyPo0UC34DKDBnr7t5gn8g@mail.gmail.com>
	<s5htxu4ezc7.wl%tiwai@suse.de>
	<s5hr4p8ez6u.wl%tiwai@suse.de>
Date: Tue, 9 Oct 2012 19:23:56 +0800
Message-ID: <CAMVG2svG+SNY7B=SiCL9taRGhdZtGKZ6javtpRBPUdvB825BEg@mail.gmail.com>
Subject: Re: [3.6-rc7] switcheroo race with Intel HDA...
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dave Airlie <airlied@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2012 18:07, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 09 Oct 2012 12:04:08 +0200,
> Takashi Iwai wrote:
>>
>> At Tue, 9 Oct 2012 00:34:09 +0800,
>> Daniel J Blueman wrote:
>> >
>> > On 8 October 2012 20:58, Takashi Iwai <tiwai@suse.de> wrote:
>> > > At Tue, 25 Sep 2012 13:20:05 +0800,
>> > > Daniel J Blueman wrote:
>> > >> On my Macbook with a discrete Nvidia GPU, there is a race between
>> > >> selecting the integrated GPU and putting the discrete GPU into D3 [1],
>> > >> reliably causing a kernel oops [2].
>> > >>
>> > >> Introducing a delay of ~1s between the calls prevents this. When the
>> > >> second 'OFF' write path executes, it looks like struct azx at
>> > >> card->private_data hasn't yet been allocated yet [3], so there is
>> > >> likely some locking missing.
>> > >
>> > > It's rather pci_get_drvdata() returning NULL (i.e. card is NULL, thus
>> > > card->private_data causes Oops).  Could you check the patch like below
>> > > and see whether you get a kernel warning (but no Oops) or the problem
>> > > gets fixed by shifting the assignment of pci drvdata?
>> > [...]
>> >
>> > Good patching. Calling pci_set_drvdata later prevents the oops in HDA,
>> > though we see unexpected 0x0 responses in the response ring buffer
>> > [1], which we don't see when there's a >~1.5s delay between IGD and
>> > OFF.
>>
>> If the previous patch fixed, it means that the switching occurred
>> during the device was being probed.  Maybe a better approach to
>> register the VGA switcheroo after the proper initialization.
>>
>> The patch below is a revised one.  Please give it a try.
>
> Also, it's not clear which card spews the spurious response.
> Apply the patch below in addition.
[...]

hda-intel: 0000:01:00.1: spurious response 0x0:0x0, last cmd=0x1f0004
$ lspci -s :1:0.1
01:00.1 Audio device: NVIDIA Corporation Device 0e1b (rev ff)

It's the NVIDIA device which presumably hasn't completed it's
transition to D3 at the time the OFF is executed.

Thanks,
  Daniel
-- 
Daniel J Blueman
