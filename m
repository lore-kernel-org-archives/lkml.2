Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2GXJGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:06:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:50413 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab2GXJGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:06:37 -0400
Message-ID: <500E6597.2050402@mev.co.uk>
Date: Tue, 24 Jul 2012 10:06:31 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: bforce1729 <bforce1729@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Need to know the size of data send from Kernel to USer Ap
References: <500E5808.1070607@gmail.com>
In-Reply-To: <500E5808.1070607@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-24 09:08, bforce1729 wrote:
> Hi,
>
> I am new to kernel programming so can anyone point me to the right
> forum/reply for the question below.
>
> I would like to implement a character device and using a node of type
> character  read and write data. However I am not sure of the length of
> data from kernel which a user app will receive, so I would like to code
> safely. If the data exceeds the application gets killed.
> Any idea or API to perform the task of knowing the data length when
> passing data to and fro from kernel to user level would be appreciated.
>
> Kernel code:
>
>                  copy_to_user(buff, kernel_msg, strlen(kernel_msg));
>
> User App:
>                  fd=open("./my_device",O_RDONLY);
> ret=read(fd,buff,strlen(buf));                        //How can I know
> the size of buff, which would be sent/filled from kernel???

I doubt you really want strlen(buf) there.  You probably want 
sizeof(buf) or something similar.  You might need to read up on what 
strlen() actually does.

Anyway, the driver's "read" file operation knows the maximum amount the 
user is asking for as it is specified in the third parameter.  The 
function should return the (non-negative) amount it is actually passing 
back to the user (which will be returned by the read() function in 
userspace), or a negative error value (which will cause read() to return 
-1 and set errno appropriately).

Also, copy_to_user() might not succeed if the user passed a bad pointer 
or bad length.  It returns 0 on success and the length of the uncopied 
part on failure.  So if copy_to_user() returns a non-zero value you 
should either return -EFAULT or work out the partial amount successfully 
read (as long as it is greater than zero) and return that.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
