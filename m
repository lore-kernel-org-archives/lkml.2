Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1BNIgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 03:36:52 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57908 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1BNIgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 03:36:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D1nnYahPYILwcT9dZdX6jNch4rCE/fGp4bOplCNBizjZksg+jh1vbTIipcW4gCoyOK
         T6qIIcX6zIfDRiHjuTiopE6/iGII57GzWa8ELas+fgq+KPR09es1w82iwSllzVdLHogK
         iqwmGhBxwUZRQeZB5zkcVqp6QS2UGRIEBvUCE=
MIME-Version: 1.0
In-Reply-To: <4D57ED29.2030801@ru.mvista.com>
References: <201102111433.41507.bzolnier@gmail.com>
	<4D57ED29.2030801@ru.mvista.com>
Date: Mon, 14 Feb 2011 09:36:49 +0100
Message-ID: <AANLkTin60En3+5saCeVuGht8w0k1b074WqKLdmo1WE5T@mail.gmail.com>
Subject: Re: [PATCH v2] ata: add CONFIG_SATA_HOST config option
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 13, 2011 at 3:39 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> On 11-02-2011 16:33, Bartlomiej Zolnierkiewicz wrote:
>
>> Add CONFIG_SATA_HOST config option (for selecting SATA Host
>> support) to make setup easier on PATA-only systems.
>
>> Additionally move SATA-specific code to libata-sata.c which
>> allows us to save ~11.5k of the output code size (x86-64) on
>> PATA-only systems for CONFIG_SATA_HOST=n:
>
>> CONFIG_SATA_HOST=y:
>>    text    data     bss     dec     hex filename
>>   44283    6576      57   50916    c6e4 drivers/ata/libata-core.o
>>   29054      16       2   29072    7190 drivers/ata/libata-eh.o
>>   20085       0      19   20104    4e88 drivers/ata/libata-sff.o
>>    8699       0       0    8699    21fb drivers/ata/libata-sata.o
>
>> CONFIG_SATA_HOST=n:
>>    text    data     bss     dec     hex filename
>>   43754    6576      57   50387    c4d3 drivers/ata/libata-core.o
>>   26775      16       2   26793    68a9 drivers/ata/libata-eh.o
>>   20144       0      19   20163    4ec3 drivers/ata/libata-sff.o
>
>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>
> [...]
>
>> Index: b/drivers/ata/libata-core.c
>> ===================================================================
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>
> [...]
>>
>> @@ -573,34 +494,26 @@ void ata_tf_to_fis(const struct ata_task
>>        fis[19] = 0;
>>  }
>
>   Hm, what about ata_tf_to_fis()? It shouldn't be needed by non-SATA stuff,
> moreover it'should be only needed by non-SFF controllers...

in theory yes but it is actually used by libata-scsi.c

>> +#ifndef CONFIG_SATA_HOST
>> +int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
>> +                     bool spm_wakeup)
>>  {
>> -       tf->command     = fis[2];       /* status */
>> -       tf->feature     = fis[3];       /* error */
>> -
>> -       tf->lbal        = fis[4];
>> -       tf->lbam        = fis[5];
>> -       tf->lbah        = fis[6];
>> -       tf->device      = fis[7];
>> -
>> -       tf->hob_lbal    = fis[8];
>> -       tf->hob_lbam    = fis[9];
>> -       tf->hob_lbah    = fis[10];
>> -
>> -       tf->nsect       = fis[12];
>> -       tf->hob_nsect   = fis[13];
>> +       return -EOPNOTSUPP;
>> +}
>> +EXPORT_SYMBOL_GPL(sata_link_scr_lpm);
>
>   Shouldn't there be empty line here?

ata_piix needs it

>> +int sata_std_hardreset(struct ata_link *link, unsigned int *class,
>> +                      unsigned long deadline)
>> +{
>> +       return -EOPNOTSUPP;
>> +}
>> +EXPORT_SYMBOL_GPL(sata_std_hardreset);
>
>   ... and here?

ditto, and it is quite useful to have possibility of building ata_piix
w/ CONFIG_SATA_HOST=n

>> Index: b/drivers/ata/libata-sata.c
>> ===================================================================
>> --- /dev/null
>> +++ b/drivers/ata/libata-sata.c
>> @@ -0,0 +1,1242 @@
>
> [...]
>>
>> +int sata_set_spd(struct ata_link *link)
>> +{
>> +       u32 scontrol;
>> +       int rc;
>> +
>> +       if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
>
>   I guess checkpatch.pl protests here...

it does ;)

[...]

>> +               goto out;
>> +
>> +       scontrol = (scontrol&  0x0f0) | 0x301;
>> +
>> +       if ((rc = sata_scr_write_flush(link, SCR_CONTROL, scontrol)))
>
>   And here...
>   I understand that you're only moving the code. Perhaps it's worth fixing
> checkpatch.pl's complaints beforehand -- I was going to look at it...

Because code is moved I preferred to leave CodingStyle changes alone
but I also think that it would be useful to fix them one day (though I
deferred the work for later due to pragmatic reasons)..

Thanks,
Bartlomiej
