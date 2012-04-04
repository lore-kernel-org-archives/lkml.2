Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2DDRKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:10:34 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36352 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab2DDRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:10:33 -0400
Message-ID: <4F7C808B.7050705@gmail.com>
Date: Wed, 04 Apr 2012 10:10:35 -0700
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <20120404030117.GA6589@ZenIV.linux.org.uk>
In-Reply-To: <20120404030117.GA6589@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/3/12 8:01 PM), Al Viro wrote:
> On Sun, Apr 01, 2012 at 03:57:42PM +0300, Alexey Dobriyan wrote:
>> Currently there is no reliable way to close all opened file descriptors
>> (which daemons need and like to do):
>>
>> * dumb close(fd) loop is slow, upper bound is unknown and
>>    can be arbitrary large,
>>
>> * /proc/self/fd is unreliable:
>>    proc may be unconfigured or not mounted at expected place.
>>    Looking at /proc/self/fd requires opening directory
>>    which may not be available due to malicious rlimit drop or ENOMEM situations.
>>    Not opening directory is equivalent to dumb close(2) loop except slower.
>>
>> BSD added closefrom(fd) which is OK for this exact purpose but suboptimal
>> on the bigger scale. closefrom(2) does only close(2) (obviously :-)
>> closefrom(2) siletly ignores errors from close(2) which in theory is not OK
>> for userspace.
>>
>> So, don't add closefrom(2), add nextfd(2).
>
> Or unshare(CLONE_FILES_EMPTY) to steal an idea from rfork(2) (Plan 9 one,
> that is - I don't remember if its *BSD analog has that).  Basically, they
> allow 3 kinds of behaviour on clone(2) analog (and unshare(2) is part of
> the same thing there):
> 	1) share descriptor table with parent (default for rfork(2))
> 	2) copy descriptor table from parent (RFFDG is set in flags)
> 	3) give child an empty descriptor table (RFCFDG is set in flags)
> They have something similar for namespace, BTW - the same share/copy/clean
> triple.

Please remember why closefrom() have "from" argument. Almost all case, people
don't cloase fd 0,1,2 (rarely and 3).

If we add 2nd argument into unshare(CLONE_FILES_EMPTY), It become more ugly than
current nextfd proposal.
