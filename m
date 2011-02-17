Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1BQMnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:43:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36757 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab1BQMnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bZshuaDanclvJrr2i3KhU4X3mSa4A4/Gbeft9cI8cMMhHJCS+W0NuuHoA5JmuniBq5
         5JoozC6hUK6a0Kg474JipIy5Iw/Dhh6x2i7po+IuetVM4TAb1uKOOE1pl87Ody/23h+j
         zb37ONL+0ljUOoVIeLuH3JYEgdyTEzLIGWtyU=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=pmWAvsp_3c4NgQYFw_ydfkOMgjDBDKgeFGf=E@mail.gmail.com>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com>
	<AANLkTi=pmWAvsp_3c4NgQYFw_ydfkOMgjDBDKgeFGf=E@mail.gmail.com>
Date: Thu, 17 Feb 2011 13:43:02 +0100
X-Google-Sender-Auth: 4CkeQ8DUK8ETVN0-48UJ4ZCIRaI
Message-ID: <AANLkTi=cMwbb2Pyv5KhGdfSuR3OwG_mpkFKNd+WrLc-_@mail.gmail.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p1HChQ3b009031

On Tue, Feb 8, 2011 at 22:12, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Feb 8, 2011 at 01:02, Dmitry Torokhov <dtor@vmware.com> wrote:
>> On m68k natural alignment is 2-byte boundary but we are trying to
>> align structures in __modver section on sizeof(void *) boundary.
>> This causes trouble when we try to access elements in this section
>> in array-like fashion when create "version" attributes for built-in
>> modules.
>>
>> Moreover, as DaveM said, we can't reliably put structures into
>> independent objects, put them into a special section, and then expect
>> array access over them (via the section boundaries) after linking the
>> objects together to just "work" due to variable alignment choices in
>> different situations. The only solution that seems to work reliably
>> is to make an array of plain pointers to the objects in question and
>> put those pointers in the special section.
>>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
>
> Thanks!
>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Can we please get this in? 2.6.38-rc5 still crashes on m68k.

Thx!

>> ---
>>  include/linux/module.h |   10 +++++-----
>>  kernel/params.c        |    9 ++++++---
>>  2 files changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 9bdf27c..9b7081a 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -174,10 +174,7 @@ extern struct module __this_module;
>>  #define MODULE_VERSION(_version)                                       \
>>        extern ssize_t __modver_version_show(struct module_attribute *, \
>>                                             struct module *, char *);  \
>> -       static struct module_version_attribute __modver_version_attr    \
>> -       __used                                                          \
>> -    __attribute__ ((__section__ ("__modver"),aligned(sizeof(void *)))) \
>> -       = {                                                             \
>> +       static struct module_version_attribute ___modver_attr = {       \
>>                .mattr  = {                                             \
>>                        .attr   = {                                     \
>>                                .name   = "version",                    \
>> @@ -187,7 +184,10 @@ extern struct module __this_module;
>>                },                                                      \
>>                .module_name    = KBUILD_MODNAME,                       \
>>                .version        = _version,                             \
>> -       }
>> +       };                                                              \
>> +       static const struct module_version_attribute                    \
>> +       __used __attribute__ ((__section__ ("__modver")))               \
>> +       * __moduleparam_const __modver_attr = &___modver_attr
>>  #endif
>>
>>  /* Optional firmware file (or files) needed by the module
>> diff --git a/kernel/params.c b/kernel/params.c
>> index 0da1411..09a08cb 100644
>> --- a/kernel/params.c
>> +++ b/kernel/params.c
>> @@ -821,15 +821,18 @@ ssize_t __modver_version_show(struct module_attribute *mattr,
>>        return sprintf(buf, "%s\n", vattr->version);
>>  }
>>
>> -extern struct module_version_attribute __start___modver[], __stop___modver[];
>> +extern const struct module_version_attribute *__start___modver[];
>> +extern const struct module_version_attribute *__stop___modver[];
>>
>>  static void __init version_sysfs_builtin(void)
>>  {
>> -       const struct module_version_attribute *vattr;
>> +       const struct module_version_attribute **p;
>>        struct module_kobject *mk;
>>        int err;
>>
>> -       for (vattr = __start___modver; vattr < __stop___modver; vattr++) {
>> +       for (p = __start___modver; p < __stop___modver; p++) {
>> +               const struct module_version_attribute *vattr = *p;
>> +
>>                mk = locate_module_kobject(vattr->module_name);
>>                if (mk) {
>>                        err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
>> --
>> 1.7.3.2

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
