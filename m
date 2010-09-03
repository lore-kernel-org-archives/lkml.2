Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0ICOrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:47:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0ICOrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qa/YyIHW3SvxVAr7ro5ZNq5cwQ7MS9jH8g6Ycfxu4TkPJvFg4pMAFH+eBfXr594O8i
         ifj4veuFHnqtJ9EzEgnvdr0SFJR3aELvbFw+tU4DTurqURMFem4UWq3RN7NZWeXysmdB
         c3fY53auXfv6fQNtzDa+YuAHSwcoQJ7Dxzua8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikRBOhTQM0gyS8_Vwu7EsetaaaEuv0owkBp7B_F@mail.gmail.com>
References: <AANLkTineCKfL-UvqfQBTZPDFeqm3Nrpb=pFnZpkSqbEQ@mail.gmail.com>
	<4C810313.80000@hp.com>
	<AANLkTikRBOhTQM0gyS8_Vwu7EsetaaaEuv0owkBp7B_F@mail.gmail.com>
Date: Fri, 3 Sep 2010 10:47:43 -0400
Message-ID: <AANLkTi=dtsjCvvoOYBiMe6+sro8Ui8P7xtMH=k808BwU@mail.gmail.com>
Subject: Re: [PATCH] sctp: prevent reading out-of-bounds memory
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh, just remembered the port number is also dereferenced, so the
second of these two checks needs to be expanded to the size of a
sockaddr_in.  Note to self: don't write patches on too little sleep.
Apologies for the unnecessary traffic.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/net/sctp/socket.c	2010-09-03 08:58:48.127080114 -0400
+++ linux-2.6.35.4/net/sctp/socket.c	2010-09-03 10:45:08.467098052 -0400
@@ -916,6 +916,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
+
+		if (walk_size + sizeof(sa_family_t) > addrs_size) {
+			kfree(kaddrs);
+			return -EINVAL;
+		}
+
 		sa_addr = (struct sockaddr *)addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa_family);

@@ -1002,6 +1008,12 @@ static int __sctp_connect(struct sock* s
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
+
+		if (walk_size + sizeof(struct sockaddr_in) > addrs_size) {
+			err = -EINVAL;
+			goto out_free;
+		}
+
 		sa_addr = (union sctp_addr *)addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa.sa_family);
 		port = ntohs(sa_addr->v4.sin_port);



On Fri, Sep 3, 2010 at 10:35 AM, Dan Rosenberg
<dan.j.rosenberg@gmail.com> wrote:
> Ha, I knew there was an easier way.  Take two:
>
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
>
> --- linux-2.6.35.4.orig/net/sctp/socket.c       2010-09-03 08:58:48.127080114 -0400
> +++ linux-2.6.35.4/net/sctp/socket.c    2010-09-03 10:28:14.929595312 -0400
> @@ -916,6 +916,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>        /* Walk through the addrs buffer and count the number of addresses. */
>        addr_buf = kaddrs;
>        while (walk_size < addrs_size) {
> +
> +               if (walk_size + sizeof(sa_family_t) > addrs_size) {
> +                       kfree(kaddrs);
> +                       return -EINVAL;
> +               }
> +
>                sa_addr = (struct sockaddr *)addr_buf;
>                af = sctp_get_af_specific(sa_addr->sa_family);
>
> @@ -1002,6 +1008,12 @@ static int __sctp_connect(struct sock* s
>        /* Walk through the addrs buffer and count the number of addresses. */
>        addr_buf = kaddrs;
>        while (walk_size < addrs_size) {
> +
> +               if (walk_size + sizeof(sa_family_t) > addrs_size) {
> +                       err = -EINVAL;
> +                       goto out_free;
> +               }
> +
>                sa_addr = (union sctp_addr *)addr_buf;
>                af = sctp_get_af_specific(sa_addr->sa.sa_family);
>                port = ntohs(sa_addr->v4.sin_port);
>
>
>>
>> Hm.. we already validate that we have the proper amount of space for a given sockaddr.
>> The only thing we are missing is making sure that there is room to get the proper address
>> family and I think you can do that without adding any extra variables:
>>
>>        if (walk_size + sizeof(sa_family_t) > addr_size) {
>>                /* Not enough room for address family */
>>                kfree(kaddrs);
>>                return -EINVAL;
>>        }
>>
>> -vlad
>>
>
> On Fri, Sep 3, 2010 at 10:15 AM, Vlad Yasevich
> <vladislav.yasevich@hp.com> wrote:
>> On 09/03/2010 09:48 AM, Dan Rosenberg wrote:
>>> Two user-controlled allocations in SCTP are subsequently dereferenced
>>> as sockaddr structs, without checking if the dereferenced struct
>>> members fall beyond the end of the allocated chunk.  There doesn't
>>> appear to be any information leakage here based on how these members
>>> are used and additional checking, but it's still worth fixing.
>>>
>>> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
>>>
>>> --- linux-2.6.35.4.orig/net/sctp/socket.c     2010-09-03 08:58:48.127080114 -0400
>>> +++ linux-2.6.35.4/net/sctp/socket.c  2010-09-03 09:22:06.337096825 -0400
>>> @@ -889,6 +889,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>>>       int err;
>>>       int addrcnt = 0;
>>>       int walk_size = 0;
>>> +     unsigned int remaining = addrs_size;
>>>       struct sockaddr *sa_addr;
>>>       void *addr_buf;
>>>       struct sctp_af *af;
>>> @@ -916,6 +917,13 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>>>       /* Walk through the addrs buffer and count the number of addresses. */
>>>       addr_buf = kaddrs;
>>>       while (walk_size < addrs_size) {
>>> +
>>> +             /* Don't read out-of-bounds memory */
>>> +             if (remaining < sizeof(struct sockaddr)) {
>>> +                     kfree(kaddrs);
>>> +                     return -EINVAL;
>>> +             }
>>> +
>>>               sa_addr = (struct sockaddr *)addr_buf;
>>>               af = sctp_get_af_specific(sa_addr->sa_family);
>>>
>>> @@ -929,6 +937,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>>>               addrcnt++;
>>>               addr_buf += af->sockaddr_len;
>>>               walk_size += af->sockaddr_len;
>>> +             remaining -= af->sockaddr_len;
>>>       }
>>>
>>>       /* Do the work. */
>>> @@ -984,6 +993,7 @@ static int __sctp_connect(struct sock* s
>>>       void *addr_buf;
>>>       unsigned short port;
>>>       unsigned int f_flags = 0;
>>> +     unsigned int remaining = addrs_size;
>>>
>>>       sp = sctp_sk(sk);
>>>       ep = sp->ep;
>>> @@ -1002,6 +1012,13 @@ static int __sctp_connect(struct sock* s
>>>       /* Walk through the addrs buffer and count the number of addresses. */
>>>       addr_buf = kaddrs;
>>>       while (walk_size < addrs_size) {
>>> +
>>> +             /* Don't read out-of-bounds memory */
>>> +             if (remaining < sizeof(union sctp_addr)) {
>>> +                     err = -EINVAL;
>>> +                     goto out_free;
>>> +             }
>>> +
>>>               sa_addr = (union sctp_addr *)addr_buf;
>>>               af = sctp_get_af_specific(sa_addr->sa.sa_family);
>>>               port = ntohs(sa_addr->v4.sin_port);
>>> @@ -1101,6 +1118,7 @@ static int __sctp_connect(struct sock* s
>>>               addrcnt++;
>>>               addr_buf += af->sockaddr_len;
>>>               walk_size += af->sockaddr_len;
>>> +             remaining -= af->sockaddr_len;
>>>       }
>>>
>>>       /* In case the user of sctp_connectx() wants an association
>>>
>>
>>
>
