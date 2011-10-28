Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab1J1P6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab1J1P6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:58:34 -0400
Message-ID: <4EAAD123.6020208@redhat.com>
Date: Fri, 28 Oct 2011 09:58:27 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Mnenhy/0.8.4 Thunderbird/3.1.15
MIME-Version: 1.0
CC: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Coreutils <coreutils@gnu.org>,
        Christian Engelmayer <christian.engelmayer@frequentis.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: rename("a", "b") would not always remove "a" on success. ?!!
References: <CAK1hOcN1ocnFh+HJWMONbUmoGtnxGvfrkxjRVs8zNmurz1xdrA@mail.gmail.com>	<4EAACAF0.4030401@draigBrady.com> <4EAACD51.5060703@redhat.com>
In-Reply-To: <4EAACD51.5060703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2011 09:42 AM, Eric Blake wrote:
>> Perhaps it could be brought up as an issue with the standards guys?
>
> We already have. And POSIX 2008 already acted on that. While you quoted
> rename(2) (which was intentionally not changed), you forgot to also read
> the POSIX wording on mv(1):
>
> http://pubs.opengroup.org/onlinepubs/9699919799/utilities/mv.html
>
> 2. If the source_file operand and destination path name the same
> existing file, then the destination path shall not be removed, and one
> of the following shall occur:
>
> a. No change is made to source_file, no error occurs, and no diagnostic
> is issued.
> b. No change is made to source_file, a diagnostic is issued to standard
> error identifying the two names, and the exit status is affected.
> c. If the source_file operand and destination path name distinct
> directory entries, then the source_file operand is removed, no error
> occurs, and no diagnostic is issued.

Contrast this to the POSIX 2001 wording for mv:

http://pubs.opengroup.org/onlinepubs/009695399/utilities/mv.html

2. The mv utility shall perform actions equivalent to the rename() 
function defined in the System Interfaces volume of IEEE Std 1003.1-2001,...

with no escape clause for identical files.  That is, POSIX 2008 
specifically inserted a new step 2 (renumbering the step 2 from POSIX 
2001 to step 3 in POSIX 2008) at GNU Coreutils' insistence that the 
requirements were wrong.  See also 
http://www.opengroup.org/austin/aardvark/latest/xcubug2.txt, and search 
for AI-169, which was where the change in wording was made; including 
this rationale:

  Note that ERN 88 was rejected in spite of the fact that
  http://www.opengroup.org/austin/mailarchives/austin-group-l/msg05155.html
  claims the original intent was to have rename detect identical
  directory entries rather than identical files.  One of the arguments
  presented for rejecting ERN 88 was that rename(2) has the property
  of preserving link count, whereas having rename("a", "b") unlink
  "a" when the two names are hard links would not.

Unfortunately, that link no longer works, so I can't point you to the 
historical conversation at the time where it was argued that changing 
rename(2) behavior would be detrimental.  But it does give enough 
context to provide an alternate interpretation of rename() semantics 
that fit the standardized behavior:  a successful rename("a","b") 
guarantees that "b" now has the same link count as "a" had prior to the 
rename call, even if that meant a hard-linked "a" had to be left 
untouched to avoid changing the link count of hard-linked "b".

-- 
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org
