Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1CQLTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:19:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39237 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1CQLTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:19:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oVSUBqhMdl5j0ixldGweEMzuwyPFRTJJwbsoVrFYnfJUG72HXoWVh3oL9SL1qznjoG
         o6fR6t3sC5z/Au8qqEU6Gh1Lc6FhTAtL8DcD981x+2UHjc+tzayrFUPpzAFM0tQDWQZz
         TfuNu1u73Fuc3/EEG9aV98yhHU4s9T24dKo/w=
MIME-Version: 1.0
In-Reply-To: <20110317104903.153050@gmx.net>
References: <20110317074356.231320@gmx.net>
	<AANLkTim2cggAu6o7iU74S47xyFfOqrSiUPOfo+2XoidB@mail.gmail.com>
	<20110317104903.153050@gmx.net>
Date: Thu, 17 Mar 2011 12:19:17 +0100
Message-ID: <AANLkTik9pQgeiKYha5mnUEFQugFwYKsHo9JZ6ZpYQhYb@mail.gmail.com>
Subject: Re: sctp panic
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: walter schloegl <sctp@muskelshirt.de>
Cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 11:49 AM, walter schloegl <sctp@muskelshirt.de> wrote:
>
> -------- Original-Nachricht --------
>> Datum: Thu, 17 Mar 2011 08:56:47 +0100
>> Von: richard -rw- weinberger <richard.weinberger@gmail.com>
>> An: sctp@muskelshirt.de
>> CC: linux-kernel@vger.kernel.org
>> Betreff: Re: sctp panic
>
>> On Thu, Mar 17, 2011 at 8:43 AM,  <sctp@muskelshirt.de> wrote:
>> > Hi
>> >
>> > when doing the actions below I get a panic.
>> >
>> > - echo 1 > /proc/sys/net/sctp/addip_enable
>> > - In a C-Programm
>> >    - socket(AF_INET,SOCK_STREAM,IPPROTO_SCTP);
>> >    - connect(....)     (with correct filled parameters)
>> >
>> > Its no process (waiting in accept) neccessary
>>
>> Can you show us the panic message and your C prorgam?
>> This would help reproducing the panic...
>
> The C-Code is:
>
> #include <sys/socket.h>
> #include <netinet/in.h>
> #include <netdb.h>
> #include <stdio.h>
> #include <errno.h>
> #include <unistd.h>
> #include "sctp.h"
>
>
> int
> main(int ac,char **av)
> {
>
>  int s;
>  char *remhost;
>  int port;
>  struct hostent *hp;
>  struct sockaddr_in server;
>
>  if (ac != 3) {
>      printf("usage: %s ip-addr port\n",av[0]);
>      exit(1);
>  }
>
>  remhost = av[1];
>  port = atoi(av[2]);
>
>
>  server.sin_port = htons(port);
>  server.sin_family = AF_INET;
>  hp = gethostbyname(remhost);
>  if (hp == 0)  {
>     fprintf(stderr,"unknown host %s\n",remhost);
>     exit(1);
>  }
>  memcpy((char *)&server.sin_addr,(char *)hp->h_addr,hp->h_length);
>
>  if ((s = socket(AF_INET,SOCK_STREAM,IPPROTO_SCTP)) < 0)  {
>      fprintf(stderr,"socket IPPROTO_SCTP proc %d  failed errno %d\n",getpid(),errno);
>      close(s);
>      exit(1);
>  }
>
>  if (connect(s,(struct sockaddr *)&server,sizeof server) < 0)        {
>         fprintf(stderr,"connect failed errno %d\n",errno);
>         close(s);
>         exit(1);
>  }
> }
>
> The crash says:
>
> crash> bt
> PID: 14646  TASK: ffff8801f40c7560  CPU: 9   COMMAND: "x"
>  #0 [ffff8801f6f5f6f0] machine_kexec at ffffffff8103697b
>  #1 [ffff8801f6f5f750] crash_kexec at ffffffff810b9078
>  #2 [ffff8801f6f5f820] oops_end at ffffffff814cc900
>  #3 [ffff8801f6f5f850] die at ffffffff8101733b
>  #4 [ffff8801f6f5f880] do_trap at ffffffff814cc1d4
>  #5 [ffff8801f6f5f8e0] do_invalid_op at ffffffff81014ee5
>  #6 [ffff8801f6f5f980] invalid_op at ffffffff81013f5b
>    [exception RIP: skb_over_panic+93]
>    RIP: ffffffff81404bdd  RSP: ffff8801f6f5fa38  RFLAGS: 00010296
>    RAX: 0000000000000083  RBX: 0000000000000040  RCX: 00000000000013f6
>    RDX: 0000000000000000  RSI: 0000000000000046  RDI: 0000000000000246
>    RBP: ffff8801f6f5fa58   R8: ffffffff818a3da0   R9: 0000000000000000
>    R10: 0000000000000001  R11: 0000000000000000  R12: ffff8801f4e11000
>    R13: 0000000000000004  R14: 000000000000003e  R15: 0000000000000001
>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffff8801f6f5fa60] skb_put at ffffffff81405c1c
>  #8 [ffff8801f6f5fa80] sctp_addto_chunk at ffffffffa0503c23
>  #9 [ffff8801f6f5fad0] sctp_make_init at ffffffffa0506705
> #10 [ffff8801f6f5fba0] sctp_sf_do_prm_asoc at ffffffffa04f81d4
> #11 [ffff8801f6f5fbd0] sctp_do_sm at ffffffffa04fd381
> #12 [ffff8801f6f5fd60] sctp_primitive_ASSOCIATE at ffffffffa0513daf
> #13 [ffff8801f6f5fd80] __sctp_connect at ffffffffa0510f09
> #14 [ffff8801f6f5fe50] sctp_connect at ffffffffa0511248
> #15 [ffff8801f6f5fe80] inet_dgram_connect at ffffffff81471b6c
> #16 [ffff8801f6f5feb0] sys_connect at ffffffff813ff747
> #17 [ffff8801f6f5ff80] system_call_fastpath at ffffffff81013172
>    RIP: 0000003015ee2150  RSP: 00007fffea7bdce8  RFLAGS: 00010206
>    RAX: 000000000000002a  RBX: ffffffff81013172  RCX: 0000000000000000
>    RDX: 0000000000000010  RSI: 00007fffea7bdd00  RDI: 0000000000000003
>    RBP: 00007fffea7bdd40   R8: 0000000000759020   R9: ff00000000000000
>    R10: 00007fffea7bda70  R11: 0000000000000246  R12: 0000000000000000
>    R13: 00007fffea7bde20  R14: 00000000004006e0  R15: 0000000000000000
>    ORIG_RAX: 000000000000002a  CS: 0033  SS: 002b
>
>
> One more Info:
> When calling my programm with 127.0.0.1 as remote ip-addr I get a:
> connect failed errno 111
>
> When calling it with a "non local" address (and also no "accept process" running) I get the Panic.
>
>
>>
>> > br
>> > walter
>> > --
>> > GMX DSL Doppel-Flat ab 19,99 Euro/mtl.! Jetzt mit
>> > gratis Handy-Flat! http://portal.gmx.net/de/go/dsl
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>>
>> --
>> Thanks,
>> //richard
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> NEU: FreePhone - kostenlos mobil telefonieren und surfen!
> Jetzt informieren: http://www.gmx.net/de/go/freephone
>

CC'ing netdev

-- 
Thanks,
//richard
