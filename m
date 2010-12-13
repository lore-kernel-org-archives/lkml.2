Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0LMXCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:02:48 -0500
Received: from adelie.canonical.com ([91.189.90.139]:51794 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab0LMXCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:02:46 -0500
Message-ID: <4D06A60D.7010409@canonical.com>
Date: Mon, 13 Dec 2010 15:02:37 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se> <4D065BDE.5020107@canonical.com> <4D068E3C.8080100@euromail.se>
In-Reply-To: <4D068E3C.8080100@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 01:21 PM, Henrik Rydberg wrote:
> On 12/13/2010 06:46 PM, Chase Douglas wrote:
>> On 12/10/2010 09:24 AM, Henrik Rydberg wrote:
>>> +- The MT_TOOL_ENVELOPE type is used to indicate that the contact position
>>> +is not well-defined, and is only used for legacy hardware. The real contact
>>> +positions are to be found within the bounding rectangle formed by the
>>> +envelope contact positions.
>>
>> By definition, this only covers rectangles with two coordinates to
>> define the shape and location. Why do we want to call it envelope? It's
>> just extra confusion to me. Why not call it MT_TOOL_RECT?
> 
> 
> The envelope contacts serve as a way to detect a small area of fingers or a
> large area of fingers. There is nothing inherently problematic with having one
> or three or more such contacts.

Then I'm more confused :).

I see one problem: devices that report two touch points, (X1, Y1) and
(X2, Y2), but in reality the touches could be at (X1, Y2) and (X2, Y1)
instead. Using a rectangle helps resolve this issue for panning and
pinching, though not for rotation.

Now, you're telling me that the envelope tool may be used for more
points than two. If I had more than two touch points, wouldn't it be on
a device that had full MT capabilities, and thus did not need envelope/rect?

The only purpose I can think of for this would be if you had up to four
fingers down that the device reported as (X1, Y1) through (X4, Y4). If
you can trust the coordinate pairs as they are, then you have full MT
and don't need this. Or, you can find the bounding rectangle defined as
the min and max of each axis. You could provide that bounding rectangle
by providing all the coordinates, but that includes potentially
incorrect data. A cleaner approach would tell userspace of the bounding
rectangle and how many fingers are down.

I'm beginning to feel that this isn't really MT at all. Instead of
fitting this into MT slots, we could define ABS_RECT_MIN and
ABS_RECT_MAX to provide the min and max X and Y values, and then use
BTN_TOOL_*TAP as usual to tell how many touches are within the
rectangle. I think this will mirror what userspace would have to
extrapolate from the MT_TOOL_ENVELOPE data anyways, so why not provide
it up front, without any MT protocol complications?

>> Please describe how to use this tool type. Its usage is different than
>> any tool type usage before, so an explanation would be helpful. Must the
>> value of the tool on the first touch be 0 until a second touch can
>> define the rect? Or, can touches always default the value to 1 since
>> we're talking about devices that only support two fingers?
> 
> 
> For a dual-touch driver sending the lower-left and upper-right corners as
> contacts, nothing really has to be done in user space. The contacts will look
> weird in a drawing program, because the actual fingers and the ones on the
> screen may diverge. The tool type indicates that this may be the case, so the
> application can take measures if it wants to. This is the primary intended usage.

Is it a requirement that the coordinates will be lower-left and
upper-right? If so, that needs to be documented somewhere. If it's not a
requirement, then userspace will likely transform the data to be
uniform, in which case we might as well make it a requirement in evdev.

This still hasn't answered the question though. Suppose I have a device
that supports two finger touches, but only in this rectangular fashion.
Can I leave MT_TOOL_ENVELOPE as 1 all the time? Or does it need to turn
on and off when two touches go down and up?

We're going to be adding support for all this to X and other display
managers. The lack of documentation for even simple things like
BTN_TOOL_DOUBLETAP has been an issue in the past. Let's do it right this
time by providing real documentation for a complex issue like this.

> A driver can use MT_TOOL_ENVELOPE also for one finger.

Isn't this what blobs are for?

>> If this is really to remedy only poor two finger devices, would it be
>> better to flag the device itself somehow to say "don't trust this
>> device's coordinate positions" (or something more elegant)? This would
>> prevent an extrapolation of tool types to multiple fingers at a time.
> 
> 
> Maybe the device also has a pen, for which the coordinates should be trusted.

The driver could specify which tools are accurate and which tools are
not, if this was the route taken to resolve this issue. However, I like
the approach outlined above better.

>> Lastly, using tool types for this seems odd since this does not signify
>> a physical tool. It merely signifies that the device coordinates cannot
>> be trusted literally. Maybe we should use some other namespace for
>> binding information across multiple touches, like MT_BIND_RECT?
> 
> 
> The envelope coordinates can be trusted to yield a smoothly moving bounding
> area, similar to tracked contacts. Completely untrusted contacts would first
> have to be processed somewhere in order to be useful, which is less desirable.

We're not talking about completely untrusted contacts. I'm also not sure
how this answers the question :).

-- Chase
