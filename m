Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0ESMMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:12:46 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:44389 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756271Ab0ESMMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:12:44 -0400
Message-ID: <4BF3D59E.1070801@euromail.se>
Date: Wed, 19 May 2010 14:12:14 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se> <1274213429-22667-2-git-send-email-rydberg@euromail.se> <20100519023727.GA21030@barra.bne.redhat.com>
In-Reply-To: <20100519023727.GA21030@barra.bne.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.129.72
X-Scan-Result: No virus found in message 1OEi8K-0005X0-4e.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OEi8K-0005X0-4e 84a474114dea6bdb4ec03ccafd0dbd62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hutterer wrote:
> On Tue, May 18, 2010 at 10:10:29PM +0200, Henrik Rydberg wrote:
>> This patch adds documentation for the SYN_MT_SLOT event and gives
>> examples of how to use the event slot protocol.
> 
> thanks, this is really nice documentation! the approach seems good, though I
> do have a few questions inline.
> 
[...]
> 
> Is there a limit on the number of slots?

The slots are dynamically allocated by the driver, so there is no practical
limit. Each slot currently takes 44 bytes, and allocating a few kilobytes of
kernel memory is not a problem.

> Will all drivers with ABS_MT_TRACKING_ID use slots? if not, how can I know
> in advance if a device may use slots or not?

Eventually, this might become true, but you are pointing at one of the weaker
points of the current setup. There is no bit field for the EV_SYN events, so
there is no way to know in advance if SYN_MT_SYNC or SYN_MT_SLOT is used. This
could quite possibly be added to the EVIO interface. Meanwhile, the method I use
is to detect the first SYN_MT_SLOT and select parser based on that information.

>> +
>> +Protocol Example B
>> +------------------
>> +
>> +Here is what a minimal event sequence for a two-contact touch would look
>> +like for a type B device:
>> +
>> +   SYN_MT_SLOT 0
>> +   ABS_MT_TRACKING_ID 45
>> +   ABS_MT_POSITION_X x[0]
>> +   ABS_MT_POSITION_Y y[0]
>> +   SYN_MT_SLOT 1
>> +   ABS_MT_TRACKING_ID 46
>> +   ABS_MT_POSITION_X x[1]
>> +   ABS_MT_POSITION_Y y[1]
>> +   SYN_REPORT
>> +
>> +Here is the sequence after moving contact 45 in the x direction:
>> +
>> +   SYN_MT_SLOT 0
>> +   ABS_MT_POSITION_X x[0]
>> +   SYN_REPORT
>> +
>> +Here is the sequence after lifting the contact in slot 0:
>> +
>> +   ABS_MT_TRACKING_ID 0
>> +   SYN_REPORT
>> +
>> +The active slot is already 0, so the SYN_MT_SLOT is omitted.  The message
>> +removes the association of slot 0 with contact 45, thereby destroying
>> +contact 45 and freeing slot 0 to be reused for another contact.
> 
> I'm probably missing something here, but how would a process know which one
> is the active slot if it didn't get the previous event?

I am assuming you are not talking about losing events in the stream, but simply
what information is available at the point of parsing it. The parser (the X
evdev driver for instance) keeps all attributes of all slots, plus a single
variable saying what slot is currently active, i.e, being modified.

If you are thinking of a setup where one program is already hooked up to the
device, and a new one comes in just as the message in question appears on the
wire, it just means the new program will have to spend some time catching up. If
this should ever become a problem, one could possibly add a send-full-state
method to the input layer, to be issued when the new program opens the device. I
doubt this will be needed in practice though, since contacts change all the time.

As a side note, the notion of a used slot depends on how the attributes of the
slot are interpreted. The method described in the document treats an
ABS_MT_TRACKING_ID value outside of the driver-specified value range as an
unused slot.

Cheers,
Henrik

