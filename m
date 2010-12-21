Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0LUUqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 15:46:19 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:38807 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab0LUUqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 15:46:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ke3j+I/lIHjetYYcac1Ia8X4MAOHz5cXAz0uyhJAh87O7fRJzmUog76UGm2ehHg4em
         rs/VXc5hDoPGMQSSZbeJgEntlGc0iDA3hy5A2yOg/u4YgUreOWGWwNg8pAhDEB2N70rh
         qpvihDf1ZsG0pFGx0Twjxl6Hukyn83I/P6tDg=
MIME-Version: 1.0
In-Reply-To: <20101221194606.GA25359@openwall.com>
References: <20101221181800.GA8166@albatros>
	<AANLkTikS6rs-AFGmtTfuRdELJ5+y=o4g1i0Xk9KDFRiv@mail.gmail.com>
	<20101221194606.GA25359@openwall.com>
Date: Tue, 21 Dec 2010 15:46:15 -0500
X-Google-Sender-Auth: 2YlBwFB4wreUjsUUIv67UldK6s8
Message-ID: <AANLkTin6_fck1SbCbX5tLvY8CPzJstqmpkJuVF-B6oC6@mail.gmail.com>
Subject: Re: [RFC] ipv4: add ICMP socket kind
From: Colin Walters <walters@verbum.org>
To: Solar Designer <solar@openwall.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Kankovsky <peak@argo.troja.mff.cuni.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 2:46 PM, Solar Designer <solar@openwall.com> wrote:
> On Tue, Dec 21, 2010 at 01:46:41PM -0500, Colin Walters wrote:
>> On Tue, Dec 21, 2010 at 1:18 PM, Vasiliy Kulikov <segooon@gmail.com> wrote:
>> > A new ping socket is created with
>> >
>> >  socket(PF_INET, SOCK_DGRAM, IPPROTO_ICMP)
>>
>> And the default is to allow any uid to do this (modulo LSM)?
>
> We intend to have this sysctl'able and to have it restricted to a group
> by default (the sysctl would set the GID) on our Linux distro,
> Openwall GNU/*/Linux.  However, we figured that it'd be tough for us to
> get this complication accepted into mainstream, so we opted to have the
> patch posted for comment without it.

Right, a sysctl was the obvious thing to have.

>> If you really have a burning desire to get rid of setuid /bin/ping,
>> why not just do it in userspace via message passing to/from a
>> privileged process, and avoid a lot of code in the kernel?
>
> Yes, we thought of that, and we don't like this solution.

...because?

> We similarly
> (but for different reasons) don't like using fscaps to grant CAP_NET_RAW
> to ping.

I am (learning now) about the fscaps drawbacks...

> We share your concern about the size of net/ipv4/ping.c introduced by
> this patch, yet this is our current proposal.

To be clear I have no personal stake in the size of net/; my concern
is more about the set of permissions granted by the default kernel
configuration.  Both from an OS developer standpoint, and also just so
I feel I can continue to explain to someone who's learning about Linux
all the interactions between the uid/gid, capabilities, SELinux, etc.
If the kernel starts adding extensions to things it historically
didn't, that gets even more complicated.

> We figured that there's little point behind such restrictions.  Just how
> is an ICMP echo request any worse than a UDP packet of the same size?
> Anyone can send the latter with current kernels.

Clearly if we could go back in time and make some changes to the
default Unix security model, one of those would probably be making
allocating TCP/UDP sockets a privileged operation in some way.  But
the ship has sailed there...

> Yet, as I have mentioned, we're in fact going to restrict this to a
> group by default and to have ping SGID - just not to expose the extra
> kernel code for direct attack by a local user.  That's in case there's a
> vulnerability in the added code.

So wait...this whole patch is to remove the setuid bit, but then
you're going to go back and add setgid?  How is that really
compellingly different and better?
