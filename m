Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0F2PzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:55:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62789 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0F2PzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:55:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d/sgIVn+2Xcg95FtHkCaSr+XtwAbZOhhJxk8/ZO1ndtcPBkR6FbXwzpmhOVFi1AZ78
         con9aXUGtl0XG0IwaoY0W8d5gyl5QmXjU8uNwEKodiReEN4otdNqeVtLJus8P7kqv7w0
         Xql6E2ziJIznoXGZ9MEzuJfc2T7tCt8Rc5hkk=
MIME-Version: 1.0
In-Reply-To: <9BC2BBFFF6E8F04094DB58B805758CE406C02B63@SHAMLVEM01.e2k.ad.ge.com>
References: <9BC2BBFFF6E8F04094DB58B805758CE406C02B63@SHAMLVEM01.e2k.ad.ge.com>
Date: Tue, 29 Jun 2010 10:50:03 -0500
Message-ID: <AANLkTinyAoii-fBeN9fLKVqTTt81Y2IhHmRp1HllGFPF@mail.gmail.com>
Subject: Re: FW: Linux preempt policy serial port communication
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: "Zhang, Yongchao (GE Healthcare)" <Yongchao.Zhang@ge.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 4:06 AM, Zhang, Yongchao (GE Healthcare)
<Yongchao.Zhang@ge.com> wrote:
> Hi,
>   We have some problems about serial port. We need your expertise. The
> detail is like this:
>
> 1.Our Goal:
>   We want to make test on serial port, and want to know whether the
> serial port communication is still OK  under heavy system load.
>
> 2.Environment:
>     1). Two computer,one is as server,another is as client.
>         The "Server" sends data to serial port. We use a serial port
> tool run on WINXP as server.
>         The "Client" reads the data from serial port,and run on Linux.
>
> 3.The way access serial port for "client" program:
>     During test procedure, we use  two kinds of way to "read" data from
> serial port. One way is "select +none block read" ,another is  "block
> read".
>     The code slice  is as the follwoing:
>         (1).select+none block read. like this:
>                   ......
>                   while(num_of_bytes < len)
>                   {
>                           //wait till notified.
>                           while((select(m_fileDescriptor+1,&m_readSet,
> NULL, NULL, NULL)) == -1 && errno == EINTR)
>                           {
>                                  usleep(1000);
>                           }
>
>                           //read data
>                           if((readBytes = ::read(m_fileDescriptor,
> (buff+num_of_bytes), (len-num_of_bytes))) == -1)
>                           {
>                                  close();
>
> printf("CS_ERR_READ_SERIAL_PORT_FAIL");
>                                  exit(0);
>                           }
>                           else
>                           {
>                                  num_of_bytes += readBytes;
>                           }
>                 }
>                 ......
>
>        (2).block read
>                first set paramer c_cc as this during init.
>                    port_settings.c_cc[VMIN ]  = 1 ;
>                    port_settings.c_cc[VTIME] = 0 ;
>                second,read directly
>                    readBytes = ::read(m_fileDescriptor,
> (buff+num_of_bytes), (len-num_of_bytes))) == -1
>
> 4. The heavy load simulation program.
>          Here we write a program to simulate heavy CPU load in linux
> system. This "heavy load program" create one thread and promote thread
> prority to 99, which is the top most in system. This thread did nothing
> but empty loop and never release CPU resource actively.The code slice as
> following:
>
>           //create this thread
>           ....
>           pthread_create(&m_hThread[1],NULL,fifo_99_1  ,(void*)&trans)
>           ....
>
>           //thread proc
>           void* fifo_99(void *para)
>           {
>               struct sched_param param;
>
>               //adjust prority to FIFO 99.
>               pthread_t thread_t     = pthread_self();
>               param.sched_priority = 99;
>               pthread_setschedparam(thread_t,SCHED_FIFO,&param);
>
>               //only cost CPU resource
>               while(1)
>               {
>                   for (int z = 0; z < 10000; z++)
>                   {
>                   }
>               }
>           }
>
> 5. Test procedure
>    (1).
>         Procedure:
>            Run serial port client program,the program is just waitting
> serial port data.  The "client" program is run with normal priority.
>            Run 99 FIFO emluator,so the CPU cost is 100% almost now.
>            Run serial tool in WindowXP,and send data to client,total
> send several groups of data.
>
>         Test result:
>            Find the "client" program could not recevie the data during
> FIFO 99 emluator running. But if break the emluator , the "client"
> program could read out all the data
>  immediately. We get know that it is "select" statement that always
> blocked without waken up if FIFO 99 running . So it seems the system
> could not notify the "serial port data received signal" to "select"
> statement in time.
>
>         Analysis &  Question:
>            Why FIFO 99 could affect on serial port read? Could you
> please point out the detail code position(maybe in serial port driver)?
> And how to avoid this to let "serial port reading" could not be
> disturbed by any other thread or process even if FIFO 99?
>
>   (2).
>        Procedure
>           The same procedure with (1). But this time we also promote
> the "client" program to FIFO 99.
>        Test result:
>           The same with (1).
>        Analysis & Question:
>           Once we doube that the thread priority of the "client"
> program is too low to get CPU resource, so we promote "client" program
> also to FIFO 99.
>           But also could not read out the data until heavy load is
> over. Maybe even high priority for "client" program have no effect on
> this.
>
>   (3).
>         Procedure:
>            The same with (1). But this time change FIFO 99 to FIFO 98,
> and also "client" program is run with normal priority.
>         Test result:
>            The "client" program could read the data in time,all is OK.
>         Analysis & Question:
>            FIFO 99,98 are both high prority in system. But 98 could not
> affect on the serial port,99 could. FIFO 99,98 are both high priority,
> why is it so much difference for serial port reading?
>
>   (4).
>         Procedure:
>            The same with (3). But this time we run two heavy load
> programs i.e. two FIFO 98 in linux system.
>         Test result:
>            There is much difference with (1) and (3).  We will find
> "client" program could receive the data but have some delay(about 2~4
> seconds delay)
>         Analysis & Question:
>            Two FIFO98 are also heavy load to system,but compared with
> FIFO 99,FIFO 98 is not so rigorous. So system maybe give "some running
> slice" to notify the "select" statement though could not be in time but
> still have opportunity to notify. Right?
>
>
>   From our tests, we want to consult with you following questions:
>
>   1. Why FIFO 99 could affect on serial port read? Could you please
> point out the detail code position(maybe in serial port driver)?  And
> how to avoid this to let "serial port reading" could not be disturbed by
> any other thread or process even if FIFO 99?
>
>   2. From procedure (2),To FIFO 99,98,why is there so much difference
> for serial port reading?
>
>
> Thanks!
>
> Best Regards!
>
> -------------------------
> Philip
> 2010.06.29
> -------------------------
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
which kernel/rt-patch are you using to do this test?
can you also list all the RT threads with their priorities, e.g.
softirqs etc, say: ps -e -o pid,rtprio,comm | grep sirq


Xianghua
