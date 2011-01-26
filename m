Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1AZSML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:12:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1AZSMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:12:08 -0500
Message-ID: <4D4059E5.7050300@redhat.com>
Date: Wed, 26 Jan 2011 15:29:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Gerd Hoffmann <kraxel@redhat.com>, Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com> <4D401CC5.4020000@redhat.com> <4D402D35.4090206@redhat.com> <20110126165132.GC29163@core.coreip.homeip.net>
In-Reply-To: <20110126165132.GC29163@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-01-2011 14:51, Dmitry Torokhov escreveu:
> On Wed, Jan 26, 2011 at 12:18:29PM -0200, Mauro Carvalho Chehab wrote:
>> diff --git a/input.c b/input.c
>> index d57a31e..a9bd5e8 100644
>> --- a/input.c
>> +++ b/input.c
>> @@ -101,8 +101,8 @@ int device_open(int nr, int verbose)
>>  		close(fd);
>>  		return -1;
>>  	}
>> -	if (EV_VERSION != version) {
>> -		fprintf(stderr, "protocol version mismatch (expected %d, got %d)\n",
>> +	if (EV_VERSION > version) {
>> +		fprintf(stderr, "protocol version mismatch (expected >= %d, got %d)\n",
>>  			EV_VERSION, version);
> 
> Please do not do this. It causes check to "float" depending on the
> version of kernel headers it was compiled against.
> 
> The check should be against concrete version (0x10000 in this case).

The idea here is to not prevent it to load if version is 0x10001.
This is actually the only change that it is really needed (after applying
your KEY_RESERVED patch to 2.6.37) for the tool to work. Reverting it causes
the error:

$ sudo ./input-kbd 2
/dev/input/event2
protocol version mismatch (expected >= 65536, got 65537)

Just applying this diff to the previous version:

$ git diff 442bc4e7697a3f20ce9a24df630324d94cd22ba6
diff --git a/input.c b/input.c
index d57a31e..a9bd5e8 100644
--- a/input.c
+++ b/input.c
@@ -101,8 +101,8 @@ int device_open(int nr, int verbose)
                close(fd);
                return -1;
        }
-       if (EV_VERSION != version) {
-               fprintf(stderr, "protocol version mismatch (expected %d, got %d)
+       if (EV_VERSION > version) {
+               fprintf(stderr, "protocol version mismatch (expected >= %d, got 
                        EV_VERSION, version);
                close(fd);
                return -1;

And, with your KEY_RESERVED patch applied to 2.6.37, the tool works
fine, with 16-bits keytables:

$ sudo ./input-kbd 2
/dev/input/event2
   bustype : BUS_I2C
   vendor  : 0x0
   product : 0x0
   version : 0
   name    : "i2c IR (i2c IR (EM2820 Winfast "
   phys    : "i2c-0/0-0030/ir0"
   bits ev : EV_SYN EV_KEY EV_MSC EV_REP

map: 28 keys, size: 65536/65536
0x0021 = 363  # KEY_CHANNEL
0x0031 =  52  # KEY_DOT
0x0035 = 359  # KEY_TIME
0x0037 = 167  # KEY_RECORD
0x0038 = 212  # KEY_CAMERA
0x0039 = 154  # KEY_CYCLEWINDOWS
0x003a = 181  # KEY_NEW
0x0060 = 403  # KEY_CHANNELDOWN
0x0061 = 405  # KEY_LAST
0x0062 =  11  # KEY_0
0x0063 =  28  # KEY_ENTER
0x0064 = 113  # KEY_MIN_INTERESTING
0x0066 = 358  # KEY_INFO
0x0070 = 356  # KEY_POWER2
0x0072 = 393  # KEY_VIDEO
0x0073 = 372  # KEY_ZOOM
0x0074 = 115  # KEY_VOLUMEUP
0x0075 =   2  # KEY_1
0x0076 =   3  # KEY_2
0x0077 =   4  # KEY_3
0x0078 = 114  # KEY_VOLUMEDOWN
0x0079 =   5  # KEY_4
0x007a =   6  # KEY_5
0x007b =   7  # KEY_6
0x007c = 402  # KEY_CHANNELUP
0x007d =   8  # KEY_7
0x007e =   9  # KEY_8
0x007f =  10  # KEY_9

(this is the original RC-5 table for the IR that comes with this device)

It will fail, however, it the keytable has 24 bits keycode:

$ sudo ir-keytable -cw /etc/rc_keymaps/pixelview_mk12 

(loads a 24 bits NEC-extended keycode, found on Pixelview MK12 remote
control)

$ sudo ./input-kbd 2
/dev/input/event2
   bustype : BUS_I2C
   vendor  : 0x0
   product : 0x0
   version : 0
   name    : "i2c IR (i2c IR (EM2820 Winfast "
   phys    : "i2c-0/0-0030/ir0"
   bits ev : EV_SYN EV_KEY EV_MSC EV_REP

bits: KEY_1
bits: KEY_2
bits: KEY_3
bits: KEY_4
bits: KEY_5
bits: KEY_6
bits: KEY_7
bits: KEY_8
bits: KEY_9
bits: KEY_0
bits: KEY_MIN_INTERESTING
bits: KEY_VOLUMEDOWN
bits: KEY_VOLUMEUP
bits: KEY_PAUSE
bits: KEY_STOP
bits: KEY_AGAIN
bits: KEY_FORWARD
bits: KEY_RECORD
bits: KEY_REWIND
bits: KEY_PLAY
bits: KEY_CAMERA
bits: KEY_SEARCH
bits: KEY_POWER2
bits: KEY_ZOOM
bits: KEY_TV
bits: KEY_RADIO
bits: KEY_TUNER
bits: KEY_VIDEO
bits: KEY_CHANNELUP
bits: KEY_CHANNELDOWN
bits: KEY_DIGITS

Instead of showing the scancode/keycode table, it shows the mapped keys as
if they were some event bits.

The current kraxel tree at http://bigendian.kraxel.org/cgit/input/
with your userspace input patch, plus my backports for upstream work fine
also with the 24-bits keycode table:

$ git reset --hard && make
[mchehab@nehalem input]$ git reset --hard && make
HEAD is now at 52f533a input-kbd - switch to using EVIOCGKEYCODE2 when available
  CC	  input-kbd.o
  LD	  input-kbd

$ sudo ./input-kbd 2
/dev/input/event2
   bustype : BUS_I2C
   vendor  : 0x0
   product : 0x0
   version : 0
   name    : "i2c IR (i2c IR (EM2820 Winfast "
   phys    : "i2c-0/0-0030/ir0"
   bits ev : EV_SYN EV_KEY EV_MSC EV_REP

map: 31 keys, size: 31/64
0x866b00 = 393  # KEY_VIDEO
0x866b01 =   2  # KEY_1
0x866b02 =  11  # KEY_0
0x866b03 = 386  # KEY_TUNER
0x866b04 = 168  # KEY_REWIND
0x866b05 =   5  # KEY_4
0x866b06 =   8  # KEY_7
0x866b07 = 385  # KEY_RADIO
0x866b08 = 207  # KEY_PLAY
0x866b09 =   6  # KEY_5
0x866b0a =   9  # KEY_8
0x866b0b =   3  # KEY_2
0x866b0c = 159  # KEY_FORWARD
0x866b0d = 377  # KEY_TV
0x866b0e = 167  # KEY_RECORD
0x866b0f = 119  # KEY_PAUSE
0x866b10 = 413  # KEY_DIGITS
0x866b12 =  10  # KEY_9
0x866b13 = 129  # KEY_AGAIN
0x866b14 = 403  # KEY_CHANNELDOWN
0x866b15 =   7  # KEY_6
0x866b16 = 402  # KEY_CHANNELUP
0x866b17 = 114  # KEY_VOLUMEDOWN
0x866b18 = 113  # KEY_MIN_INTERESTING
0x866b19 = 212  # KEY_CAMERA
0x866b1a = 217  # KEY_SEARCH
0x866b1b =   4  # KEY_3
0x866b1c = 372  # KEY_ZOOM
0x866b1d = 128  # KEY_STOP
0x866b1e = 356  # KEY_POWER2
0x866b1f = 115  # KEY_VOLUMEUP

Cheers,
Mauro
