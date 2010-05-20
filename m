Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0ETRxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:53:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45766 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0ETRxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hyhDIgQsBApm998SiuP16vYsNgpe7D4vFstbTa5IN1iAGdx6vhWR2ijQZ1MPWt08rW
         ZwAAKFpYd22phbab5MAvkRTg2Ig7AzSN2ER613I0/8o8h7SMKJfEuNrShERyCxMjxdEr
         as5qu4Ym8PmodMKvjN5rbir1Ii21rjtjGPuDw=
MIME-Version: 1.0
In-Reply-To: <AANLkTinIa_FCrLscMr0qHtZa7V_qs7Im0rTWu8EbGtxt@mail.gmail.com>
References: <AANLkTinIa_FCrLscMr0qHtZa7V_qs7Im0rTWu8EbGtxt@mail.gmail.com>
Date: Thu, 20 May 2010 19:53:03 +0200
Message-ID: <AANLkTingurFim5kWw_uLh0xJNiweYkissvf-L9Rv5ypL@mail.gmail.com>
Subject: Re: [Libcg-devel] Some changes to taskstats.
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Rafael Tinoco <rafael.tinoco@locaweb.com.br>
Cc: balbir <balbir@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

I am cc'ing the LKML and dropping libcg-devel, since the LKML is the
right place to discuss this.

On Thu, May 20, 2010 at 3:38 AM, Rafael Tinoco
<rafael.tinoco@locaweb.com.br> wrote:
> Hello Balbir,
>
> Im sure this isn't the right place to post it, but I would like some
> help to change a few things inside taskstats struct on main kernel.
> Since you have its copyright maybe its a little bit easier.
>
> Ive changed:
>
> /usr/src/linux-2.6.33.2/include/linux/task_io_accounting_ops.h
> /usr/src/linux-2.6.33.2/include/linux/task_io_accounting.h
> /usr/src/linux-2.6.33.2/include/linux/taskstats.h
> /usr/src/linux-2.6.33.2/net/socket.c
>
> Extending the TASKSTATS_HAS_IO_ACCOUNTING (at the end)
>
> with
>
>  167         __u64   read_net_bytes;         /* bytes of network read I/O */
>  168         __u64   write_net_bytes;        /* bytes of network write I/O */
>
> And the taskstats_ops.h
>
> with
>
>  56 static inline void task_io_account_read_net(size_t bytes)
>  57 {
>  58         current->ioac.read_net_bytes += bytes;
>  59 }
>  60
>  61 static inline void task_io_account_write_net(size_t bytes)
>  62 {
>  63         current->ioac.write_net_bytes += bytes;
>  64 }
>
> And socket.c
>
> with
>
>  673 static inline int __sock_recvmsg_nosec(struct kiocb *iocb, struct
> socket *sock,
>  674                                        struct msghdr *msg, size_t
> size, int flags)
>  675 {
>  676         int ret = 0;
>  677         struct sock_iocb *si = kiocb_to_siocb(iocb);
>  678
>  679         si->sock = sock;
>  680         si->scm = NULL;
>  681         si->msg = msg;
>  682         si->size = size;
>  683         si->flags = flags;
>  684
>  685         ret = sock->ops->recvmsg(iocb, sock, msg, size, flags);
>  686
>  687         if(ret > 0)
>  688             task_io_account_read_net(ret);
>  689
>  690         return ret;
>  691 }
>
> And taskstats.h (at the end)
>
> with
>
>  167         __u64   read_net_bytes;         /* bytes of network read I/O */
>  168         __u64   write_net_bytes;        /* bytes of network write I/O */
>
>
> So i could have read and written bytes per pid inside taskstats. This
> is needed for my "ustats" program Ill be releasing soon.
> Ustats is responsible for UID accounting of everything happening about
> procs (using cn_msg and taskstats).
> It maintains statistics of a short timequantum (less than 1 sec) and a
> long timequantum (1 minute) of EVERYTHING any user is actually doing
> or has done. It maintains lists of active and inactive processes..
> couting cpu, mem, disks and network.
> In some benchmark tests, with 1500 users Im using less than 0.3% of
> cpu each 1 or 2 secs for all this accounting. The results are sent to
> a queue for mongodb distribution.
>
> Take a look:
>
> { "host" : "hm2306",  "uid" : "11494",  "name" : "revistaharvard",
> "time" : "2010:05:12:13:36",  "ucpu" : "2424000",  "pucpu" : "17.24",
> "scpu" : "652000",  "pscpu" : "4.64",  "mem" : "413.41"  }
> { "host" : "hm2306",  "uid" : "11562",  "name" :
> "anunciecarrogratis1",  "time" : "2010:05:12:13:36",  "ucpu" :
> "96000",  "pucpu" : "0.68",  "scpu" : "44000",  "pscpu" : "0.31",
> "mem" : "17.03"  }
> { "host" : "hm2306",  "uid" : "11568",  "name" : "altodoengenho",
> "time" : "2010:05:12:13:36",  "ucpu" : "612000",  "pucpu" : "4.42",
> "scpu" : "192000",  "pscpu" : "1.39",  "mem" : "106.77"  }
> { "host" : "hm2306",  "uid" : "11421",  "name" : "callplusnet",
> "time" : "2010:05:12:13:36",  "ucpu" : "100000",  "pucpu" : "0.72",
> "scpu" : "16000",  "pscpu" : "0.12",  "mem" : "15.05"  }
> { "host" : "hm2306",  "uid" : "11190",  "name" : "okimagem",  "time" :
> "2010:05:12:13:36",  "ucpu" : "472000",  "pucpu" : "3.48",  "scpu" :
> "48000",  "pscpu" : "0.35",  "mem" : "41.63"  }
> { "host" : "hm2306",  "uid" : "11444",  "name" : "ammp1",  "time" :
> "2010:05:12:13:36",  "ucpu" : "300000",  "pucpu" : "2.24",  "scpu" :
> "36000",  "pscpu" : "0.27",  "mem" : "33.57"  }
> { "host" : "hm2306",  "uid" : "11498",  "name" : "atleticomonteazul",
> "time" : "2010:05:12:13:36",  "ucpu" : "296000",  "pucpu" : "2.34",
> "scpu" : "72000",  "pscpu" : "0.57",  "mem" : "45.86"  }
> { "host" : "hm2306",  "uid" : "11586",  "name" : "ou",  "time" :
> "2010:05:12:13:36",  "ucpu" : "248000",  "pucpu" : "2.01",  "scpu" :
> "96000",  "pscpu" : "0.78",  "mem" : "28.69"  }
> { "host" : "hm2306",  "uid" : "11479",  "name" : "firefriend1",
> "time" : "2010:05:12:13:36",  "ucpu" : "88000",  "pucpu" : "0.71",
> "scpu" : "28000",  "pscpu" : "0.23",  "mem" : "14.89"  }
> { "host" : "hm2306",  "uid" : "11469",  "name" : "enotel2",  "time" :
> "2010:05:12:13:36",  "ucpu" : "152000",  "pucpu" : "1.24",  "scpu" :
> "40000",  "pscpu" : "0.33",  "mem" : "29.29"  }
> { "host" : "hm2306",  "uid" : "11551",  "name" : "abrhrj1",  "time" :
> "2010:05:12:13:36",  "ucpu" : "760000",  "pucpu" : "6.55",  "scpu" :
> "156000",  "pscpu" : "1.34",  "mem" : "93.41"  }
> { "host" : "hm2306",  "uid" : "11538",  "name" : "k6s2",  "time" :
> "2010:05:12:13:36",  "ucpu" : "2576000",  "pucpu" : "22.23",  "scpu" :
> "416000",  "pscpu" : "3.59",  "mem" : "256.04"  }
> { "host" : "hm2306",  "uid" : "11537",  "name" : "indacarros",  "time"
> : "2010:05:12:13:36",  "ucpu" : "304000",  "pucpu" : "2.67",  "scpu" :
> "68000",  "pscpu" : "0.60",  "mem" : "26.57"  }
>
> So, basically pucpu and pscpu is a percentage of 0% to ncpu * 100%
> based on my timequantum. The error rates are in 0.0001 order.
> Im loosing 0.07% of statistics (very very very short lived processes),
> only on extreme high load conditions.
>
> Do you think its possible changes like this in the taskstats struct
> and socket.c ?
>
> With my changes:
>
> [inaddy][inerddao][ustats]$ netcat -l -p 8080
> hehehehehe
>
> Gave me exactly:
> proc_event_exit: pid 1000 uid 1564 (ucpu: 0) (scpu: 0) (teste: 11)
>
> teste is read bytes of this process (10 + \0).
>
> Thank you
>
> Regards
>
> Rafael Tinoco
>
> ------------------------------------------------------------------------------
>
> _______________________________________________
> Libcg-devel mailing list
> Libcg-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/libcg-devel
>
