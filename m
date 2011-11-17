Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1KQSKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:10:02 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54615 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1KQSKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:10:00 -0500
MIME-Version: 1.0
In-Reply-To: <4EC49D13.2010206@linux.intel.com>
References: <1321478739-8978-1-git-send-email-keescook@chromium.org>
	<1321478739-8978-2-git-send-email-keescook@chromium.org>
	<4EC49D13.2010206@linux.intel.com>
Date: Thu, 17 Nov 2011 10:10:00 -0800
X-Google-Sender-Auth: XLzdjnizhHOujSMejxw31nfiKHY
Message-ID: <CAGXu5jJfhLjBN4hEUNv5DaivJJaX5=15+JaC0VEON+mfDSeF+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] ramoops: use pstore interface
From: Kees Cook <keescook@chromium.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 9:35 PM, Chen Gong <gong.chen@linux.intel.com> wrote:
> 于 2011/11/17 5:25, Kees Cook 写道:
>> Instead of using /dev/mem directly, use the common pstore infrastructure
>> to handle Oops gathering and extraction.
>> [...]
>> +       /* Explicitly only take the first part of any new crash.
>> +        * If our buffer is larger than kmsg_bytes, this can never happen,
>> +        * and if our buffer is smaller than kmsg_bytes, we don't want the
>> +        * report split across multiple records. */
>> +       if (part != 1)
>> +               return -ENOSPC;
>
> why only one part is accepted? You are afraid about your filename style?

The logic in ramoops doesn't expect to have a split-up report. Since
pstore doesn't limit reports to kmsg_bytes in size (it actually splits
reports on pstore_info.bufsize) this is a non-issue, but in the case
that a platform defines very small ramoops record sizes, I didn't want
the extra stuff written to additional records. If ramoops gains real
record headers ever, this can change, of course. In the meantime, it
should be defensive.

>> +       /* Only a single ramoops area allowed at a time, so fail extra
>> +        * probes.
>> +        */
>> +       if (cxt->max_count)
>> +               goto fail3;
>
> Should be fail4
> [...]
> In some situations fail4 maybe hits max_count != 0, so here max_count should
> be cleared. I think you should rearrange the logic in this function
> carefully.

Ah, thanks for the catch. All the error targets got messed up. I'll
fix them and name them instead of using numbers.

>> +       /* TODO(kees): It shouldn't be possible to remove ramoops since
>> +        * pstore doesn't support unregistering yet. When it does, remove
>> +        * this early return and add the unregister where noted below.
>> +        */
>> +       return -EBUSY;
>
> This style is not reasonable. Maybe it should have a better wrap.

I'm not sure I understand what you mean. It's wrapped roughly to
column 75 already. What would be better for this comment? Or did you
mean I shouldn't have unreachable code?

> BTW, you need to update Documentation/ramoops.txt

Ah! Yes, thanks for the reminder.

-Kees

-- 
Kees Cook
ChromeOS Security
