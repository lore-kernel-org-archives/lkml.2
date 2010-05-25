Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab0EYQdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:33:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56238 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab0EYQdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BaYhhuIIUJcWI407RETc4+ei9gV3nShmMOTjiwK2MB/ap6MfcqVYS+D7G8M9ikxZ1k
         2mtJQatJLXyzfEkx1Dw+G85fVD5HkTWmvyuJelOPqO6x1FfMxYVIxZEm2FzHOCN91YDq
         CavuJrlBl8/N9lgSHFh1eCukpmbtmJp/yIyrQ=
MIME-Version: 1.0
In-Reply-To: <4BFABF40.30700@euromail.se>
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
	 <1274567437-2818-2-git-send-email-rydberg@euromail.se>
	 <20100523102413.2fee3f4c.rdunlap@xenotime.net>
	 <4BF9ABC7.9090208@euromail.se>
	 <AANLkTimQIIPiah962ar_TRZvJZpqCFvh-KLXxakbUHmZ@mail.gmail.com>
	 <4BFA272B.7090602@euromail.se>
	 <AANLkTimro6rna8MTqylaE2cnr_7Fif68Ldc6czLk7UDG@mail.gmail.com>
	 <4BFABF40.30700@euromail.se>
Date: Tue, 25 May 2010 09:33:32 -0700
Message-ID: <AANLkTilW4xkWdenQE3429jTmFDXabnAAx0iIUnSXNVQR@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev4)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 11:02 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Ping Cheng wrote:
>> On Mon, May 24, 2010 at 12:13 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>> Ping Cheng wrote:
>>>> What I am thinking is that we only need one SYN_ call for both _MT_
>>>> and regular data combined, which is a call to input_sync() at the end
>>>> of the whole packet. The SYN_MT_ can be replaced by the following
>>>> example, which I think is more "client-friendly". This solution is
>>>> based on the fact that the major difference between type A and type B
>>>> is whether we need to filter the data or not:
>>>>
>>>> ABS_MT_RANDOM 0
>>>> ABS_MT_POSITION_X x[0]
>>>> ABS_MT_POSITION_Y y[0]
>>>> ABS_MT_ RANDOM 1
>>>> ABS_MT_POSITION_X x[1]
>>>> ABS_MT_POSITION_Y y[1]
>>>> SYN_REPORT
>>>>
>>>> input_set_abs_params(input_dev, ABS_MT_RANDOM, 0, 2, 0, 0);
>>>>
>>>> would tell the clients that they can expect two random touches.
>>> And if you do s/RANDOM/SLOT/, you end up with what? ;-)
>>
>> Haha, I know what you are thinking :).
>>
>> Maybe I didn't make my point clear.  I didn't mean to make SLOT
>> backward compatible.  I meant to replace SYN_MT_REPORT event with the
>> ABS_MT_ RANDOM label so we only sync the whole packet once at the end.
>> This way both types of MT_ data follow the same input event reporting
>> flow....
>
> You mean changing the type A protocol, breaking the current code base? That is a
> big no-no.

Hi Henrik,

I saw your new patchset, very much appreciated.  There are reasons
that I am not "attacking" your new patches:

1.  I don't want to ruin your hard work;
2.  It would be easier for others to understand what I am talking
about along this thread.

I came up with another "crazy" idea which doesn't break the existing
type A protocol/code. We leave the existing code as is. However, we
make the new SLOT format support both type A and type B. This unified
approach offers a benefit for future X driver and client developers to
treat both types the same way.

As we've discussed before, the major difference between type A and
type B is the filtering and tracking mechanism. Filtering is tied to
the tracking ID since we do not apply filter to the untracked touch
poinsts. From this point of view, ABS_MT_SLOT doesn't lead to the
filter. The existence of an unique tracking ID triggers the filter.

Pure type A format (no filter applied):

ABS_MT_SLOT 0
ABS_MT_POSITION_X x[0]
ABS_MT_POSITION_Y y[0]
ABS_MT_ SLOT 1
ABS_MT_POSITION_X x[1]
ABS_MT_POSITION_Y y[1]
SYN_REPORT

Pure type B format (filter applied upon the detection of a tracking ID)

ABS_MT_SLOT 0
ABS_MT_TRACKING_ID 45
ABS_MT_POSITION_X x[0]
ABS_MT_POSITION_Y y[0]
ABS_MT_SLOT 1
ABS_MT_TRACKING_ID 46
ABS_MT_POSITION_X x[1]
ABS_MT_POSITION_Y y[1]
SYN_REPORT

Hybrid format (filter applied only when a tracking ID is detected):

ABS_MT_SLOT 0
ABS_MT_POSITION_X x[0]
ABS_MT_POSITION_Y y[0]
ABS_MT_SLOT 1
ABS_MT_TRACKING_ID 46
ABS_MT_POSITION_X x[1]
ABS_MT_POSITION_Y y[1]
ABS_MT_SLOT 2
ABS_MT_TRACKING_ID 20
ABS_MT_POSITION_X x[2]
ABS_MT_POSITION_Y y[2]
SYN_REPORT

So, one protocol covers both cases for the future.

Ping
