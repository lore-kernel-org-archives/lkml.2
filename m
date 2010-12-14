Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab0LNPCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:02:31 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38119 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431Ab0LNPC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:02:29 -0500
MIME-Version: 1.0
In-Reply-To: <4D06A60D.7010409@canonical.com>
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se>
	<4D065BDE.5020107@canonical.com>
	<4D068E3C.8080100@euromail.se>
	<4D06A60D.7010409@canonical.com>
Date: Tue, 14 Dec 2010 09:02:28 -0600
Message-ID: <AANLkTi=SM55_+0gMyn4EsgJH8VOuxWiVt+eBpNgpJzdU@mail.gmail.com>
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
From: Chris Bagwell <chris@cnpbagwell.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 5:02 PM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 12/13/2010 01:21 PM, Henrik Rydberg wrote:
>> On 12/13/2010 06:46 PM, Chase Douglas wrote:
>>> On 12/10/2010 09:24 AM, Henrik Rydberg wrote:
>>>> +- The MT_TOOL_ENVELOPE type is used to indicate that the contact position
>>>> +is not well-defined, and is only used for legacy hardware. The real contact
>>>> +positions are to be found within the bounding rectangle formed by the
>>>> +envelope contact positions.
>>>
>>> By definition, this only covers rectangles with two coordinates to
>>> define the shape and location. Why do we want to call it envelope? It's
>>> just extra confusion to me. Why not call it MT_TOOL_RECT?
>>
>>
>> The envelope contacts serve as a way to detect a small area of fingers or a
>> large area of fingers. There is nothing inherently problematic with having one
>> or three or more such contacts.
>
> Then I'm more confused :).
>
> I see one problem: devices that report two touch points, (X1, Y1) and
> (X2, Y2), but in reality the touches could be at (X1, Y2) and (X2, Y1)
> instead. Using a rectangle helps resolve this issue for panning and
> pinching, though not for rotation.

Just a note that I'm sure we can do synaptic's version of rotation. 1
finger fixed and other finger drawing an arc around fixed finger.

>
> Now, you're telling me that the envelope tool may be used for more
> points than two. If I had more than two touch points, wouldn't it be on
> a device that had full MT capabilities, and thus did not need envelope/rect?
>
> The only purpose I can think of for this would be if you had up to four
> fingers down that the device reported as (X1, Y1) through (X4, Y4). If
> you can trust the coordinate pairs as they are, then you have full MT
> and don't need this. Or, you can find the bounding rectangle defined as
> the min and max of each axis. You could provide that bounding rectangle
> by providing all the coordinates, but that includes potentially
> incorrect data. A cleaner approach would tell userspace of the bounding
> rectangle and how many fingers are down.
>
> I'm beginning to feel that this isn't really MT at all. Instead of
> fitting this into MT slots, we could define ABS_RECT_MIN and
> ABS_RECT_MAX to provide the min and max X and Y values, and then use
> BTN_TOOL_*TAP as usual to tell how many touches are within the
> rectangle. I think this will mirror what userspace would have to
> extrapolate from the MT_TOOL_ENVELOPE data anyways, so why not provide
> it up front, without any MT protocol complications?

How would you do it this have?  Do you mean
ABS_RECT_MIN_X/ABS_RECT_MIN_Y/ABS_RECT_MAX_X/ABS_RECT_MAX_Y?  That
would be possible.  If we are talking about a form of tool changing
though I'd prefer to use MT because its nice and isolated from ST tool
changing.

BTW, in the patches so far, we've not listed a finger count report
have we?  So as of now BTN_TOOL_*TAP is still required with
MT_TOOL_ENVELOPE to get finger count (I know topic came up so may have
missed in patch).

>
>>> Please describe how to use this tool type. Its usage is different than
>>> any tool type usage before, so an explanation would be helpful. Must the
>>> value of the tool on the first touch be 0 until a second touch can
>>> define the rect? Or, can touches always default the value to 1 since
>>> we're talking about devices that only support two fingers?
>>
>>
>> For a dual-touch driver sending the lower-left and upper-right corners as
>> contacts, nothing really has to be done in user space. The contacts will look
>> weird in a drawing program, because the actual fingers and the ones on the
>> screen may diverge. The tool type indicates that this may be the case, so the
>> application can take measures if it wants to. This is the primary intended usage.
>
> Is it a requirement that the coordinates will be lower-left and
> upper-right? If so, that needs to be documented somewhere. If it's not a
> requirement, then userspace will likely transform the data to be
> uniform, in which case we might as well make it a requirement in evdev.

Probably should enforce some rule.  Sample usage in synaptics does it
this way.  There are a few variation possible then sample usage.

>
> This still hasn't answered the question though. Suppose I have a device
> that supports two finger touches, but only in this rectangular fashion.
> Can I leave MT_TOOL_ENVELOPE as 1 all the time? Or does it need to turn
> on and off when two touches go down and up?

I think MT_TOOL_ENVELOPE=0 when no touches.  For 1 touch case we need
to decide if we still create a rectangle by duplicating values, set on
corner of rectangle to (0,0), or stop reporting the rectangle and
require user to look at either BTN_TOOL_FINGER's ABS_X/ABS_Y or
alternatively report a MT_TOOL_FINGER in slot 0 with its POSITION_X/Y.
 The (0,0) in slot 1 of tool MT_TOOL_ENVELOPE is easiest I think for
kernel side and user side to process but reads a little strange.

>
> We're going to be adding support for all this to X and other display
> managers. The lack of documentation for even simple things like
> BTN_TOOL_DOUBLETAP has been an issue in the past. Let's do it right this
> time by providing real documentation for a complex issue like this.
>
>> A driver can use MT_TOOL_ENVELOPE also for one finger.
>
> Isn't this what blobs are for?
>
>>> If this is really to remedy only poor two finger devices, would it be
>>> better to flag the device itself somehow to say "don't trust this
>>> device's coordinate positions" (or something more elegant)? This would
>>> prevent an extrapolation of tool types to multiple fingers at a time.
>>
>>
>> Maybe the device also has a pen, for which the coordinates should be trusted.
>
> The driver could specify which tools are accurate and which tools are
> not, if this was the route taken to resolve this issue. However, I like
> the approach outlined above better.

I see this as what we are doing.  MT_TOOL_PEN is accurate.
MT_TOOL_FINGER is accurate.  MT_TOOL_ENVELOPE is not but is special
and requires 2 slots to be bound together.  We could create
MT_TOOL_FUZZY_FINGER as well and send raw data  to userland and let
them do their own rectangle logic but I'm not sure we should.
Rectangles seem pretty simple solution to iffy hardware.  I'm not
caught up in doing this threw MT reports but is pretty nice way to
isolate it.

Chris

>
>>> Lastly, using tool types for this seems odd since this does not signify
>>> a physical tool. It merely signifies that the device coordinates cannot
>>> be trusted literally. Maybe we should use some other namespace for
>>> binding information across multiple touches, like MT_BIND_RECT?
>>
>>
>> The envelope coordinates can be trusted to yield a smoothly moving bounding
>> area, similar to tracked contacts. Completely untrusted contacts would first
>> have to be processed somewhere in order to be useful, which is less desirable.
>
> We're not talking about completely untrusted contacts. I'm also not sure
> how this answers the question :).
>
> -- Chase
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
