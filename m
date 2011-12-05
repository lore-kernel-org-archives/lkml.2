Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab1LEXlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:41:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42519 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab1LEXlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:41:09 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1112041201371.32730-100000@netrider.rowland.org>
References: <1322997454-22955-1-git-send-email-linkinjeon@gmail.com>
	<Pine.LNX.4.44L0.1112041201371.32730-100000@netrider.rowland.org>
Date: Tue, 6 Dec 2011 08:41:08 +0900
Message-ID: <CAKYAXd-c9-UgMsa=VJXkvd7k=jPFZXCmQQZEh6eBiFbDayg6bw@mail.gmail.com>
Subject: Re: [PATCH] nls: add surrogate pair support in nls utf8.
From: Namjae Jeon <linkinjeon@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/5 Alan Stern <stern@rowland.harvard.edu>:
> On Sun, 4 Dec 2011, Namjae Jeon wrote:
>
>> It allows surrogate pair in nls utf8.
>
> That's a pretty brief description.
okay~ I will rewrite more.
>
>> --- a/fs/nls/nls_utf8.c
>> +++ b/fs/nls/nls_utf8.c
>> @@ -30,13 +30,24 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
>>  {
>>       int n;
>>       unicode_t u;
>> +     u16 *op;
>>
>> +     op = uni;
>>       n = utf8_to_utf32(rawstring, boundlen, &u);
>> -     if (n < 0 || u > MAX_WCHAR_T) {
>> +     if (n < 0 || u > UNICODE_MAX) {
>>               *uni = 0x003f;  /* ? */
>>               return -EINVAL;
>>       }
>> -     *uni = (wchar_t) u;
>> +
>> +     if (u >= PLANE_SIZE) {
>> +             u -= PLANE_SIZE;
>> +             *op++ = (wchar_t) (SURROGATE_PAIR |
>> +             ((u >> 10) & SURROGATE_BITS));
>> +             *op++ = (wchar_t) (SURROGATE_PAIR |
>> +             SURROGATE_LOW | (u & SURROGATE_BITS));
>> +             } else
>> +                     *op++ = (wchar_t) u;
>> +
>>       return n;
>>  }
>
> Firstly, have you checked whether the callers of this function expect
> to receive back more than one 16-bit value?  Maybe you will overrun
> their buffers by doing this.
Hi Alan.
first Thanks for your review.
yes, you're right. and yes I have checked it on FAT fs,  I will try to
post the below FAT patch after this patch is applied.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -555,7 +555,10 @@ xlate_to_uni(const unsigned char *name, int len,
unsigned char *outname,
                                                return -EINVAL;
                                        ip += charlen;
                                        i += charlen;
-                                       op += 2;
+                                       if (charlen == sizeof(unicode_t))
+                                               op += 4;
+                                       else
+                                               op += 2;
                                }
                        }
-----------------------------------------------------------------------------------------------------------------------------------

>
> Secondly, you shouldn't have to make all these changes.  Just call
> utf8s_to_utf16s(); then all you have to worry about is changing an
> invalid character to a '?'.
Currently there are two paths along mount option. if using -o utf8
mount option, utf8s_to_utf16s have been used in xlate_to_uni of FAT.
and if using iocharset=utf8, char2uni have been used..
nls->char2uni works on a single charachter while utf8s_to_utf16s works
on whole string.
when the mount option(uni_xlate) that require scanning character by
character is used it is needed.
>
> Alan Stern
>
