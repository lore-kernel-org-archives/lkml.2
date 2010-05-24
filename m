Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab0EXJul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 05:50:41 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:36226 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab0EXJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 05:50:39 -0400
Message-ID: <4BFA4BB0.7070002@euromail.se>
Date: Mon, 24 May 2010 11:49:36 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Ping Cheng <pinglinux@gmail.com>, Rafi Rubin <rafi@seas.upenn.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se> <1274213429-22667-2-git-send-email-rydberg@euromail.se> <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com> <4BF4E00A.30206@euromail.se> <AANLkTinYX96zokFF6Rc-3_gxIrMZmvMS_pw3YdQD6CG4@mail.gmail.com> <1274455140.1871.8.camel@tron> <AANLkTimemw0iAslk6jeuwf0LGRgCo0-2Mvpgso42CP5Z@mail.gmail.com> <4BF6FA55.6040900@euromail.se> <20100524052530.GD16369@barra> <AANLkTimoAPwV8IUox5MpOrFsefdte15dSCmNnuZ7bCOn@mail.gmail.com> <20100524061503.GA20447@barra.redhat.com>
In-Reply-To: <20100524061503.GA20447@barra.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OGUI2-0003nL-Aw.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OGUI2-0003nL-Aw dc3efb07eaabe468d93a528d9787e2b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hutterer wrote:
[...]
>>> This is confusing me now :)
>>>
>>> How would a device get multiple x/y coordinates for a single contact? I
>>> could understand a range of coordinates but that's what we have the
>>> ABS_MT_WIDTH_MAJOR/MINOR for. If a touchpoint sends two different x/y
>>> coordinates, wouldn't that be two touchpoints, tracked individually and thus
>>> with a different tracking ID?
>>>
>>> I read the example above as _the_ example for using blob IDs to combine
>>> multiple contacts into one semantic contact.
>> As Henrik pointed out, the current BLOB format is for "more generic
>> contact forms", such as rectangles or ellipses.  They are special
>> blobs. A generic (true) blob doesn't have to have a regular shape.  It
>> is most likely in an irregular shape. They would be represented in an
>> array of points/contacts/(x,y)s,  whichever term works for you :).
> 
> Hmm. I always assumed blob is for irregular shapes, and rectangles or others
> are just subsets of irregular shapes (with slightly less 'ir', maybe).
> So what would be the difference between these two event streams?
> 
> ABS_SLOT 0
> ABS_MT_TRACKING_ID 14
> ABS_MT_POSITION_X x[0]
> ABS_MT_POSITION_Y y[0]
> ABS_SLOT 1
> ABS_MT_TRACKING_ID 14
> ABS_MT_POSITION_X x[1]
> ABS_MT_POSITION_Y y[1]
> 
> 
> ABS_SLOT 0
> ABS_MT_TRACKING_ID 14
> ABS_MT_BLOB_ID 1
> ABS_MT_POSITION_X x[0]
> ABS_MT_POSITION_Y y[0]
> ABS_SLOT 1
> ABS_MT_BLOB_ID 1
> ABS_MT_TRACKING_ID 15
> ABS_MT_POSITION_X x[1]
> ABS_MT_POSITION_Y y[1]

I, for one, prefer a third example, but for some other time. I know, the first
example is my fault, but it was created to illustrate that it is possible, not
that it is a particularly good idea. :-)

For type A devices, in the absence of identifiable contacts, there is room for
geometrical groupings of different kinds. Since all data is transferred between
synchronization points, the ABS_MT_BLOB_ID serves this purpose well.

However, for type B devices, seeking to reduce bandwidth by adding the concept
of identifiable contacts, it does not make sense to send overly detailed data.
If anything, the shape of a contact should be communicated in a simpler way,
maybe by extending the ABS_MT_TOOL_TYPE list.

Here is an attempt to capture the above constraints in the documentation:

@@ -244,15 +244,16 @@ MT_TOOL_PEN [2].
 ABS_MT_BLOB_ID

 The BLOB_ID groups several packets together into one arbitrarily shaped
-contact. This is a low-level anonymous grouping, and should not be confused
-with the high-level trackingID [5]. Most kernel drivers will not have blob
-capability, and can safely omit the event.
+contact. This is a low-level anonymous grouping for type A devices, and
+should not be confused with the high-level trackingID [5]. Most type A
+devices do not have blob capability, so drivers can safely omit this event.

 ABS_MT_TRACKING_ID

 The TRACKING_ID identifies an initiated contact throughout its life cycle
-[5]. There are currently only a few devices that support it, so this event
-should normally be omitted.
+[5]. This event is mandatory for type B devices. The value range of the
+TRACKING_ID should be large enough to ensure unique identification of a
+contact maintained over an extended period of time.

Henrik

