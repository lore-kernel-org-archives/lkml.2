Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab2JXA3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:29:00 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:59656 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445Ab2JXA26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:28:58 -0400
MIME-Version: 1.0
In-Reply-To: <1351030129.2459.17.camel@palomino.walls.org>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
	<1351022246-8201-15-git-send-email-elezegarcia@gmail.com>
	<1351030129.2459.17.camel@palomino.walls.org>
Date: Tue, 23 Oct 2012 21:28:57 -0300
Message-ID: <CALF0-+UOJDFXB+U=owDzvs+RsrXR2501O=McH4FnrzYGfNi6QQ@mail.gmail.com>
Subject: Re: [PATCH 15/23] ivtv: Replace memcpy with struct assignment
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andy,

On Tue, Oct 23, 2012 at 7:08 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Tue, 2012-10-23 at 16:57 -0300, Ezequiel Garcia wrote:
>> This kind of memcpy() is error-prone. Its replacement with a struct
>> assignment is prefered because it's type-safe and much easier to read.
>
> This one is a code maintenance win. :)
>
> See my comments at the end for the difference in assembled code on an
> AMD x86_64 CPU using
> $ gcc --version
> gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)
>
>
>> Found by coccinelle. Hand patched and reviewed.
>> Tested by compilation only.
>>
>> A simplified version of the semantic match that finds this problem is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> identifier struct_name;
>> struct struct_name to;
>> struct struct_name from;
>> expression E;
>> @@
>> -memcpy(&(to), &(from), E);
>> +to = from;
>> // </smpl>
>>
>> Cc: Andy Walls <awalls@md.metrocast.net>
>
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
>
>
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> ---
>>  drivers/media/pci/ivtv/ivtv-i2c.c |   12 ++++--------
>>  1 files changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
>> index d47f41a..27a8466 100644
>> --- a/drivers/media/pci/ivtv/ivtv-i2c.c
>> +++ b/drivers/media/pci/ivtv/ivtv-i2c.c
>> @@ -719,13 +719,10 @@ int init_ivtv_i2c(struct ivtv *itv)
>>               return -ENODEV;
>>       }
>>       if (itv->options.newi2c > 0) {
>> -             memcpy(&itv->i2c_adap, &ivtv_i2c_adap_hw_template,
>> -                    sizeof(struct i2c_adapter));
>> +             itv->i2c_adap = ivtv_i2c_adap_hw_template;
>>       } else {
>> -             memcpy(&itv->i2c_adap, &ivtv_i2c_adap_template,
>> -                    sizeof(struct i2c_adapter));
>> -             memcpy(&itv->i2c_algo, &ivtv_i2c_algo_template,
>> -                    sizeof(struct i2c_algo_bit_data));
>> +             itv->i2c_adap = ivtv_i2c_adap_template;
>> +             itv->i2c_algo = ivtv_i2c_algo_template;
>>       }
>>       itv->i2c_algo.udelay = itv->options.i2c_clock_period / 2;
>>       itv->i2c_algo.data = itv;
>> @@ -735,8 +732,7 @@ int init_ivtv_i2c(struct ivtv *itv)
>>               itv->instance);
>>       i2c_set_adapdata(&itv->i2c_adap, &itv->v4l2_dev);
>>
>> -     memcpy(&itv->i2c_client, &ivtv_i2c_client_template,
>> -            sizeof(struct i2c_client));
>> +     itv->i2c_client = ivtv_i2c_client_template;
>>       itv->i2c_client.adapter = &itv->i2c_adap;
>>       itv->i2c_adap.dev.parent = &itv->pdev->dev;
>>
>
> I looked at the generated assembly with only this last change
> implemented:
>
> $ objdump -h -r -d -l -s orig-ivtv-i2c.o.sav | less
> [...]
>  07e0 00000000 69767476 20696e74 65726e61  ....ivtv interna
>  07f0 6c000000 00000000 00000000 00000000  l...............
>  0800 00000000 00000000 00000000 00000000  ................
>  0810 00000000 00000000 00000000 00000000  ................
>  0820 00000000 00000000 00000000 00000000  ................
>  0830 00000000 00000000 00000000 00000000  ................
> [...]
> init_ivtv_i2c():
> /home/andy/cx18dev/git/media_tree/drivers/media/video/ivtv/ivtv-i2c.c:738
>     13bb:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi
>                         13be: R_X86_64_32S      .rodata+0x7e0
>     13c2:       48 8d bb 30 04 01 00    lea    0x10430(%rbx),%rdi
>     13c9:       b9 5a 00 00 00          mov    $0x5a,%ecx
>     13ce:       f3 48 a5                rep movsq %ds:(%rsi),%es:(%rdi)
>
>
> $ objdump -h -r -d -l -s orig-ivtv-i2c.o.sav | less
> [...]
>  07e0 00000000 69767476 20696e74 65726e61  ....ivtv interna
>  07f0 6c000000 00000000 00000000 00000000  l...............
>  0800 00000000 00000000 00000000 00000000  ................
>  0810 00000000 00000000 00000000 00000000  ................
>  0820 00000000 00000000 00000000 00000000  ................
>  0830 00000000 00000000 00000000 00000000  ................
> [...]
> init_ivtv_i2c():
> /home/andy/cx18dev/git/media_tree/drivers/media/video/ivtv/ivtv-i2c.c:738
>     13bb:       48 8d bb 30 04 01 00    lea    0x10430(%rbx),%rdi
>     13c2:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi
>                         13c5: R_X86_64_32S      .rodata+0x7e0
>     13c9:       b9 5a 00 00 00          mov    $0x5a,%ecx
>     13ce:       f3 48 a5                rep movsq %ds:(%rsi),%es:(%rdi)
>
>
> The generated code is reordered, but essentially identical.  So I guess
> in this instance, the preprocessor defines resolved such that an x86-64
> optimized memcpy() function was not used from the linux kernel source.
>
> Since all of these memcpy()'s are only called once for each board at
> board initialization, performance here really doesn't matter here
> anyway.  (Unless one is insanely trying to shave microseconds off boot
> time :P )
>
> With other memcpy()/assignement_operator replacement patches, you may
> wish to keep performance in mind, if you are patching a frequently
> called function.
>

Thanks for your thorough review on generated assembly.
It's certainly very helpful.

However, IMHO, this kind of memcpy/assignment can't generate
any performance difference, and we shouldn't worry about this
unless it's a very-very-very hot path.

On the other side, am I being too naive? I'd like to hear others opinion.

Again: thanks!

    Ezequiel
