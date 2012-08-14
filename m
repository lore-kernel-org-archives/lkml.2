Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2HNLHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:07:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43948 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2HNLHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:07:08 -0400
MIME-Version: 1.0
In-Reply-To: <5028447E.7000208@gmail.com>
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
	<1344783205-2384-8-git-send-email-dh.herrmann@googlemail.com>
	<5028447E.7000208@gmail.com>
Date: Tue, 14 Aug 2012 13:07:06 +0200
Message-ID: <CANq1E4TawZ7d=dvKjCi_r3ai9yo3kyMMYJAPh_0wV4T68Xpqng@mail.gmail.com>
Subject: Re: [PATCH 07/11] fblog: allow selecting fbs via sysfs and module-parameters
From: David Herrmann <dh.herrmann@googlemail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan

On Mon, Aug 13, 2012 at 2:04 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 13/08/12 00:53, David Herrmann wrote:
>> +static ssize_t fblog_dev_active_show(struct device *dev,
>> +                                  struct device_attribute *attr,
>> +                                  char *buf)
>> +{
>> +     struct fblog_fb *fb = to_fblog_dev(dev);
>> +
>> +     return snprintf(buf, PAGE_SIZE, "%d\n",
>> +                     !!test_bit(FBLOG_OPEN, &fb->flags));
>
> Nitpick. sprintf is okay here, %d is rarely longer than PAGE_SIZE :-).
>
>> +}
>> +
>> +static ssize_t fblog_dev_active_store(struct device *dev,
>> +                                   struct device_attribute *attr,
>> +                                   const char *buf,
>> +                                   size_t count)
>> +{
>> +     struct fblog_fb *fb = to_fblog_dev(dev);
>> +     unsigned long num;
>> +     int ret = 0;
>> +
>> +     num = simple_strtoul(buf, NULL, 10);
>
> kstrtoul is preferred these days I think, it also catches errors.
>
>> +
>> +     mutex_lock(&fb->info->lock);
>> +     if (num)
>> +             ret = fblog_open(fb);
>> +     else
>> +             fblog_close(fb, false);
>> +     mutex_unlock(&fb->info->lock);
>> +
>> +     return ret ? ret : count;
>
> Nitpick, you can use gcc's shortcut form of the ? operator here:
>
>         return ret ?: count;
>
>> @@ -186,7 +228,20 @@ static void fblog_do_register(struct fb_info *info, bool force)
>>               return;
>>       }
>>
>> -     fblog_open(fb);
>> +     ret = device_create_file(&fb->dev, &dev_attr_active);
>> +     if (ret) {
>> +             pr_err("fblog: cannot create sysfs entry");
>
> Shouldn't need the "fblog: " prefix, since you have pr_fmt defined.
>
>> +             /* do not open fb if we cannot create control file */
>> +             do_open = false;
>> +     }
>> +
>> +     if (!activate_on_hotplug)
>> +             do_open = false;
>> +     if (main_only && info->node != 0)
>> +             do_open = false;
>> +
>> +     if (do_open)
>> +             fblog_open(fb);
>>  }
>>
>>  static void fblog_register(struct fb_info *info, bool force)

All four fixes make sense, thanks!
David
