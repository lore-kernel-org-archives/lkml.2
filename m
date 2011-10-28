Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab1J1PmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:42:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449Ab1J1PmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:42:18 -0400
Message-ID: <4EAACD51.5060703@redhat.com>
Date: Fri, 28 Oct 2011 09:42:09 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Mnenhy/0.8.4 Thunderbird/3.1.15
MIME-Version: 1.0
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
CC: Denys Vlasenko <vda.linux@googlemail.com>, Coreutils <coreutils@gnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Engelmayer <christian.engelmayer@frequentis.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: rename("a", "b") would not always remove "a" on success. ?!!
References: <CAK1hOcN1ocnFh+HJWMONbUmoGtnxGvfrkxjRVs8zNmurz1xdrA@mail.gmail.com> <4EAACAF0.4030401@draigBrady.com>
In-Reply-To: <4EAACAF0.4030401@draigBrady.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2011 09:32 AM, Pádraig Brady wrote:
>> http://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html
>>
>> 'If the old argument and the new argument resolve to either .... or different
>> directory entries for the same existing file, rename() shall return
>> successfully and perform no other action.'
>>
>> It's incredible they had audacity to put such nonsense into standard.
>>
>> The page says in "RATIONALE" section:
>>
>> 'The specification that if old and new refer to the same file is
>> intended to guarantee that:
>>
>> rename("x", "x");
>>
>> does not remove the file.'
>>
>> Why didn't they just explicitly say that they actually want THIS
>> particular case to work correctly, not OTHER cases to be fucked up?!

Because it is historical precedent, and changing it now would break 
software that has come to expect this behavior on hard links.

>>
>>
>> Anyway. My question is, does it really need to be implemented in Linux?
>> It looks bogus to me, and it basically requires any program
>> to contain a work-around for this case. For example, mv from util-linux
>> apparently already has a workaround:
>>
>> $ touch a; ln a b
>> $ strace mv a b
>> ...
>> stat64("b", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>> lstat64("a", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>> lstat64("b", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>> geteuid32()                             = 0
>> unlink("a")                             = 0
>> close(0)                                = 0
>> close(1)                                = 0
>> close(2)                                = 0
>> exit_group(0)                           = ?
>
> mv is from coreutils BTW.
> Here is the related comment from the source:
>
> "Set *UNLINK_SRC if we've determined that the caller wants to do
> `rename (a, b)' where `a' and `b' are distinct hard links to the same
> file. In that case, the caller should try to unlink `a' and then return
> successfully.  Ideally, we wouldn't have to do that, and we'd be
> able to rely on rename to remove the source file.  However, POSIX
> mistakenly requires that such a rename call do *nothing* and return
> successfully."
>
> Perhaps it could be brought up as an issue with the standards guys?

We already have.  And POSIX 2008 already acted on that.  While you 
quoted rename(2) (which was intentionally not changed), you forgot to 
also read the POSIX wording on mv(1):

http://pubs.opengroup.org/onlinepubs/9699919799/utilities/mv.html

2. If the source_file operand and destination path name the same 
existing file, then the destination path shall not be removed, and one 
of the following shall occur:

    a. No change is made to source_file, no error occurs, and no 
diagnostic is issued.
    b. No change is made to source_file, a diagnostic is issued to 
standard error identifying the two names, and the exit status is affected.
    c. If the source_file operand and destination path name distinct 
directory entries, then the source_file operand is removed, no error 
occurs, and no diagnostic is issued.

2a is the naive approach (using rename(2) semantics)
2b is the typical mv(1) approach (IIRC, both Solaris and BSD mv 
independently implemented this mode)
2c is the GNU coreutils approach (make mv(1) do what you meant, even 
though rename(2) is _required_ to do nothing)

Do NOT change the Linux kernel to "fix" rename(2); that will only cause 
more heartache by deviating from the standard.

-- 
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org
