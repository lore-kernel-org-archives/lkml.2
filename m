Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab0CaH0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:26:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53205 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab0CaH0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xcNXX3WCbu0SkxPBrprOhNc23EcEnhGGTW554BBQhjl/FHor9xSqOH1bCK8+PguIqZ
         vp0FxB8nvztkpnfdqYGMXZ55tA/QLk7uQP2H61k1u1yr4vyl8xTFRbNcV7n5HNqdQuub
         qcflOdz2uBKyBKFssDfbZN1EDqocAvQR0UH18=
MIME-Version: 1.0
In-Reply-To: <20100330222302.GK30031@ZenIV.linux.org.uk>
References: <alpine.LNX.2.00.1003310009440.30178@laptop>
	 <20100330222302.GK30031@ZenIV.linux.org.uk>
Date: Wed, 31 Mar 2010 09:26:36 +0200
Message-ID: <h2m58f704b21003310026mab69619fi1d2a62be998a89bf@mail.gmail.com>
Subject: Re: [PATCH] audit: Reactive rules
From: Juraj Hlista <juro.hlista@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: sgrubb@redhat.com, mitr@redhat.com, linux-kernel@vger.kernel.org,
       linux-audit@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 12:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Mar 31, 2010 at 12:17:11AM +0200, Juraj Hlista wrote:
>> From: Juraj Hlista <juro.hlista@gmail.com>
>>
>> Add support for reactive rules. An audit rule can contain more than one reaction. The reactions are identified by numbers in the kernel and by strings in the user space.
>
> Huh?  We already have a way to associate a unique key with a rule; what does
> that patch offer that can't be happily handled by userland with what we
> already have?
>
If the key was used to associate reactions with a rule, it could be
done, for example, by adding "react-" prefix to the key (-F
key=react-r1). In order to detect if there was a match found with a
reactive rule, every single audit event would have to be checked
whether it includes the key with "react-" prefix, which is not
effective.

There is no need parsing audit events and check if they have such a
key. When there was found a match with a reactive rule, the patch adds
a new record at the beginning of an audit event, for example:

type=REACT_RULE msg=audit(1270026004.497:4): react=1
type=SYSCALL msg=audit(1270026004.497:4): arch=c000003e syscall=2
success=yes exit=3 a0=7fff8022f767 a1=941 a2=1b6 a3=7fff8022e040
items=2 ppid=2777 pid=2804 auid=4294967295 uid=0 gid=0 euid=0 suid=0
fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=4294967295 comm="touch"
exe="/bin/touch" key=(null)
type=CWD msg=audit(1270026004.497:4):  cwd="/root"
type=PATH msg=audit(1270026004.497:4): item=0 name="/tmp/" inode=8112
dev=08:02 mode=041777 ouid=0 ogid=0 rdev=00:00
type=PATH msg=audit(1270026004.497:4): item=1 name="/tmp/file"
inode=9400 dev=08:02 mode=0100644 ouid=0 ogid=0 rdev=00:00

The user space only checks the type of the record instead of parsing
it and looking for the keys. The REACT_RULE record has only a list of
reactions - mapping reaction numbers to strings is described in:

https://www.redhat.com/archives/linux-audit/2010-March/msg00040.html
