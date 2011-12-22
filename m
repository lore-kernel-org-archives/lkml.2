Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab1LVUXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:23:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1LVUXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:23:11 -0500
Message-ID: <4EF391A6.2040504@redhat.com>
Date: Thu, 22 Dec 2011 21:23:02 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition
 devices
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com> <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com> <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
In-Reply-To: <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2011 08:44 PM, Linus Torvalds wrote:
>>> >>  This kind of crazy needs to go away.
>> >
>> >  What crazy?  It's not a permission problem.  Sending a SCSI command to a
>> >  partition makes no sense.  A permission problem implies that somehow you
>> >  should be able to fix it by granting additional permissions, which is not
>> >  the case here.
> Ahh, I misread the intention here, and didn't notice that it was doing
> it on the stupid SCSI ioctl commands, not the lowlevel SCSI "cmd". The
> fact that the changelog talked about sending read/write commands down
> to the disk confused me.
>
> But please do use ENOIOCTLCMD directly then, instead of using ENOTTY
> and turning it into ENOIOCTLCMD.

I disagree.  ENOTTY is perfect in all cases except the compat_ioctl 
(which I'm not denying is ugly, but beautifying it would make everything 
else ugly).

In fact ENOTTY means "fail", ENOIOCTLCMD means "handle this elsewhere". 
  Only with compat_ioctl it makes sense to "handle this elsewhere" (we 
know that we will get it again in the non-compat fallback path, and 
return -ENOTTY).

Secondarily, ENOIOCTLCMD is ultimately turned into EINVAL when the 
system call returns (not ENOTTY).

Paolo
