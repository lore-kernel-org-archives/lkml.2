Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1DHR7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:59:53 -0400
Received: from mail.nec-labs.com ([138.15.200.209]:50634 "EHLO
	mail.nec-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab1DHR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:59:50 -0400
X-Greylist: delayed 1232 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Apr 2011 13:59:49 EDT
Message-ID: <4D9F4844.7090908@nec-labs.com>
Date: Fri, 08 Apr 2011 13:39:16 -0400
From: Steve Rago <sar@nec-labs.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Allow O_SYNC to be set by fcntl(F_SETFL)
References: <4D6824A4.6030009@nec-labs.com> <20110407143719.4044c00d.akpm@linux-foundation.org>
In-Reply-To: <20110407143719.4044c00d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 05:37 PM, Andrew Morton wrote:
> (did I ever reply to this?  I meant to ;))
>
> On Fri, 25 Feb 2011 16:52:36 -0500
> Steve Rago<sar@nec-labs.com>  wrote:
>
>> This has probably been a problem since day 1 (I ran into this running the 2.4 kernel years ago; finally got around to
>> fixing it).  The problem is that fcntl(fd, F_SETFL, flags|O_SYNC) appears to work, but silently ignores the O_SYNC flag.
>>    Opening the file with O_SYNC works okay, but setting it later on via fcntl doesn't work.
>>
>>
>> Signed-off-by: Steve Rago<sar@nec-labs.com>
>> ---
>>    fs/fcntl.c |    2 +-
>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/fcntl.c b/fs/fcntl.c
>> index cb10261..afd233a 100644
>> --- a/fs/fcntl.c
>> +++ b/fs/fcntl.c
>> @@ -143,7 +143,7 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
>>           return ret;
>>    }
>>
>> -#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
>> +#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME | O_SYNC)
>
> Does any standard say that we should do this?
> http://pubs.opengroup.org/onlinepubs/007908799/xsh/fcntl.html does, I
> guess.

It's required by the Single UNIX Specification (POSIX.1).  All other major platforms allow it to be set via fcntl.  See 
bugzilla.kernel.org bug ID #5994.

>
> I worry a bit that this change will surprise people.  For example, this
> person:
> http://koders.com/c/fidA34D8D5EE9AA5D0AB0F3C604678E2E935E5B0246.aspx?s=dupa
> is going to wonder why his app suddenly got a lot slower!
>
> Sadly, the kernel silently ignores invalid set bits in `arg', so we
> have no reliable way of signaling to the user that our behaviour here
> changed.
>
> I wonder if we should sync the file when someone sets O_SYNC this way.
> If we don't then there is a period during which we have an fd which has
> O_SYNC set, but it has pending unwritten data.  An O_SYNC fd should
> never be in such a state!

Why not?  If I write something in non-synchronous mode, then change the file descriptor to synchronous mode, I should 
not make any assumptions about what was written prior to this point.  If I care that much, I'll call fsync.  All that 
matters is that the operating system honors the contract as specified by the system call API.

>
> Ho hum.  yes, I guess we should apply the patch.  But it would have
> been better to not have screwed this up in the first place!
>
>

Agreed.  Thanks for not letting this fall through the cracks.

Steve
