Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2D3GnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:43:05 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:43886 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab2D3GnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:43:03 -0400
Message-ID: <4F9E3474.2050405@msgid.tls.msk.ru>
Date: Mon, 30 Apr 2012 10:43:00 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ian Kent <raven@themaw.net>,
        Thomas Meyer <thomas@m3y3r.de>, autofs@vger.kernel.org
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized
 pipe
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com> <4F9E30BF.4030704@msgid.tls.msk.ru>
In-Reply-To: <4F9E30BF.4030704@msgid.tls.msk.ru>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.04.2012 10:27, Michael Tokarev wrote:
>> On 04/29/2012 01:54 PM, Linux Kernel Mailing List wrote:
>>>     However, a prettier solution exists now thanks to the packetized pipe
>>>     mode.  By marking the communication pipe as being packetized (by simply
>>>     setting the O_DIRECT flag), we can always just write the bigger packet
>>>     size, and if user-space does a smaller read, it will just get that
>>>     partial end result and the extra alignment padding will simply be thrown
>>>     away.
> 
>> +static inline int autofs_prepare_pipe(struct file *pipe)
>> +{
>> +	if (!pipe->f_op || !pipe->f_op->write)
>> +		return -EINVAL;
>> +	if (!S_ISFIFO(pipe->f_dentry->d_inode->i_mode))
>> +		return -EINVAL;
>> +	/* We want a packet pipe */
>> +	pipe->f_flags |= O_DIRECT;
>> +	return 0;
>> +}
>> +
> 
> @@ -376,7 +376,7 @@ static int autofs_dev_ioctl_setpipefd(st
>  			err = -EBADF;
>  			goto out;
>  		}
> -		if (!pipe->f_op || !pipe->f_op->write) {
> +		if (autofs_prepare_pipe(pipe) < 0) {
>  			err = -EPIPE;
>  			fput(pipe);
>  			goto out;
> 
> I've one more concern.  I'm not sure but I think there's some
> risk still.  This packetizing gets applied to all VERSIONS of
> the autofs PROTOCOL.  Which means it will be applied to the
> lowest supported version (3) TOO, but did that version read
> whole packets too?

I think this is a false alarm.  I checked autofs v3 and v4
userspace code (found on  http://www.kernel.org/pub/linux/daemons/autofs )
and they both read whole packet at once, not piece-wise.

I didn't test if any of these actually work with any current
kernel, however ;)

Thanks,

/mjt
