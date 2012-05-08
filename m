Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2EHHbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:31:10 -0400
Received: from smtp.nokia.com ([147.243.128.24]:20441 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab2EHHbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:31:08 -0400
Message-ID: <4FA8CBAD.8020608@iki.fi>
Date: Tue, 08 May 2012 10:30:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120429 Firefox/12.0 SeaMonkey/2.9.1
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@redhat.com, remi@remlab.net
Subject: Re: [PATCH v2 1/1] v4l2: use __u32 rather than enums in ioctl() structs
References: <1336400869-32421-1-git-send-email-sakari.ailus@iki.fi> <201205071728.52329.hverkuil@xs4all.nl>
In-Reply-To: <201205071728.52329.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for your coments.

Hans Verkuil wrote:
> On Mon May 7 2012 16:27:49 Sakari Ailus wrote:
>> From: Rémi Denis-Courmont <remi@remlab.net>
>>
>> V4L2 uses the enum type in IOCTL arguments in IOCTLs that were defined until
>> the use of enum was considered less than ideal. Recently Rémi Denis-Courmont
>> brought up the issue by proposing a patch to convert the enums to unsigned:
>>
>> <URL:http://www.spinics.net/lists/linux-media/msg46167.html>
>>
>> This sparked a long discussion where another solution to the issue was
>> proposed: two sets of IOCTL structures, one with __u32 and the other with
>> enums, and conversion code between the two:
>>
>> <URL:http://www.spinics.net/lists/linux-media/msg47168.html>
>>
>> Both approaches implement a complete solution that resolves the problem. The
>> first one is simple but requires assuming enums and __u32 are the same in
>> size (so we won't break the ABI) while the second one is more complex and
>> less clean but does not require making that assumption.
>>
>> The issue boils down to whether enums are fundamentally different from __u32
>> or not, and can the former be substituted by the latter. During the
>> discussion it was concluded that the __u32 has the same size as enums on all
>> archs Linux is supported: it has not been shown that replacing those enums
>> in IOCTL arguments would break neither source or binary compatibility. If no
>> such reason is found, just replacing the enums with __u32s is the way to go.
>>
>> This is what this patch does. This patch is slightly different from Remi's
>> first RFC (link above): it uses __u32 instead of unsigned and also changes
>> the arguments of VIDIOC_G_PRIORITY and VIDIOC_S_PRIORITY.
>>
>> Signed-off-by: Rémi Denis-Courmont <remi@remlab.net>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>> Changes since v1:
>>
>> - Fixes according to comments by Hans Verkuil:
>>   - Update documentation
>>   - Also remove enums in compat32 code
>>
>>  Documentation/DocBook/media/v4l/io.xml             |   12 +++--
>>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |   10 +++--
>>  Documentation/DocBook/media/v4l/vidioc-cropcap.xml |    4 +-
>>  .../DocBook/media/v4l/vidioc-enum-fmt.xml          |    4 +-
>>  Documentation/DocBook/media/v4l/vidioc-g-crop.xml  |    4 +-
>>  Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |    2 +-
>>  .../DocBook/media/v4l/vidioc-g-frequency.xml       |    6 +-
>>  Documentation/DocBook/media/v4l/vidioc-g-parm.xml  |    5 +-
>>  .../DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml  |    2 +-
>>  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |    2 +-
>>  .../DocBook/media/v4l/vidioc-queryctrl.xml         |    2 +-
>>  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |    7 ++-
>>  .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    5 +-
>>  drivers/media/video/v4l2-compat-ioctl32.c          |   12 +++---
>>  include/linux/videodev2.h                          |   46 ++++++++++----------
>>  15 files changed, 65 insertions(+), 58 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
>> index b815929..fd6aca2 100644
>> --- a/Documentation/DocBook/media/v4l/io.xml
>> +++ b/Documentation/DocBook/media/v4l/io.xml
>> @@ -543,12 +543,13 @@ and can range from zero to the number of buffers allocated
>>  with the &VIDIOC-REQBUFS; ioctl (&v4l2-requestbuffers; <structfield>count</structfield>) minus one.</entry>
>>  	  </row>
>>  	  <row>
>> -	    <entry>&v4l2-buf-type;</entry>
>> +	    <entry>__u32</entry>
> 
> The problem with replacing &v4l2-buf-type; by __u32 is that you loose the link
> to the v4l2-buf-type enum.
> 
>>  	    <entry><structfield>type</structfield></entry>
>>  	    <entry></entry>
>>  	    <entry>Type of the buffer, same as &v4l2-format;
> 
> I would change this to something like:
> 
> Type of the buffer (see enum &v4l2-buf-type;), same as...
> 
> Same for all the other similar cases. Annoying, I know, but I believe it is
> important to have these links available.

The links are available in each of the spots enums were replaced. In
many cases they already existed so I haven't added new ones in that
case. The typical from I've used is "See <xref linkend="enum" />." This
could be mentioned to have more direct relation to the enum.

In many cases the IOCTL documentation itself specifies the valid values.
Especially in those cases the enum should be given as reference only.
Perhaps it'll also make sense to revisit these places where e.g. only
some buffer types are mentioned to be valid in a context of an IOCTL,
but this is out of the scope of this patch IMO.

>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index 5a09ac3..585e4b4 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -292,10 +292,10 @@ struct v4l2_pix_format {
>>  	__u32         		width;
>>  	__u32			height;
>>  	__u32			pixelformat;
>> -	enum v4l2_field  	field;
>> +	__u32			field;
> 
> Same here: you need a comment like "/* see enum v4l2_field */" to keep the
> association between the field and the possible value.

These ones I simply forgot. I'll fix this and repost.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
