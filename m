Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab1J1PdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:33:14 -0400
Received: from mail1.vodafone.ie ([213.233.128.43]:13406 "EHLO
	mail1.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab1J1PdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:33:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0EABbLqk5tTi6y/2dsb2JhbAAMN6lSgwQBAQEBAgEyAUYFCwsNAQoJFg8JAwIBAgFFBg0BBwEBh34Is3KJAwSZWYwU
Message-ID: <4EAACAF0.4030401@draigBrady.com>
Date: Fri, 28 Oct 2011 16:32:00 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Engelmayer <christian.engelmayer@frequentis.com>,
        Coreutils <coreutils@gnu.org>
Subject: Re: rename("a", "b") would not always remove "a" on success. ?!!
References: <CAK1hOcN1ocnFh+HJWMONbUmoGtnxGvfrkxjRVs8zNmurz1xdrA@mail.gmail.com>
In-Reply-To: <CAK1hOcN1ocnFh+HJWMONbUmoGtnxGvfrkxjRVs8zNmurz1xdrA@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2011 04:25 PM, Denys Vlasenko wrote:
> Hi,
> 
> One of my users stumbled over a problem when power failure
> hit his system at rename() and the filesystem he uses
> (I don't know which) ended up having both old and new
> file names in the directory. Basically, he ended up with
> one file with two hardlinks pointing to it.
> 
> IOW: the scenario does not require unlucky power offs
> to reproduce, just "ln a b" would do.
> 
> In his case these two particular hardlinks were pointing
> to rotated log files.
> 
> When system restarted, it eventually tried to rotate files
> again, via rename("a", "b").
> rename succeeded, but since they are hardlinks, rename
> did NOT remove "a".
> Which made the logger process very confused.
> 
> 
> The user dug into it and discovered that SUS actually
> specifies this insane behavior:
> 
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html
> 
> 'If the old argument and the new argument resolve to either .... or different
> directory entries for the same existing file, rename() shall return
> successfully and perform no other action.'
> 
> It's incredible they had audacity to put such nonsense into standard.
> 
> The page says in "RATIONALE" section:
> 
> 'The specification that if old and new refer to the same file is
> intended to guarantee that:
> 
> rename("x", "x");
> 
> does not remove the file.'
> 
> Why didn't they just explicitly say that they actually want THIS
> particular case to work correctly, not OTHER cases to be fucked up?!
> 
> 
> Anyway. My question is, does it really need to be implemented in Linux?
> It looks bogus to me, and it basically requires any program
> to contain a work-around for this case. For example, mv from util-linux
> apparently already has a workaround:
> 
> $ touch a; ln a b
> $ strace mv a b
> ...
> stat64("b", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> lstat64("a", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> lstat64("b", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> geteuid32()                             = 0
> unlink("a")                             = 0
> close(0)                                = 0
> close(1)                                = 0
> close(2)                                = 0
> exit_group(0)                           = ?

mv is from coreutils BTW.
Here is the related comment from the source:

"Set *UNLINK_SRC if we've determined that the caller wants to do
`rename (a, b)' where `a' and `b' are distinct hard links to the same
file. In that case, the caller should try to unlink `a' and then return
successfully.  Ideally, we wouldn't have to do that, and we'd be
able to rely on rename to remove the source file.  However, POSIX
mistakenly requires that such a rename call do *nothing* and return
successfully."

Perhaps it could be brought up as an issue with the standards guys?

cheers,
Pádraig.
