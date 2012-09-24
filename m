Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2IXRIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:08:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47202 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2IXRIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:08:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAHCeSFqmeOkKySxMUXgtnev+HL-NC6MdmeuDYONymYaNczb7RA@mail.gmail.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
 <20120921174952.GF7264@google.com> <CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
 <20120921183515.GI7264@google.com> <CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
 <20120921192720.GJ7264@google.com> <CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
 <CAK7N6vpuJnnAp2xCUG_20aSVzT9aXhZRFrkVtfO3qOKE7gZ0Eg@mail.gmail.com>
 <5A9BC72FD5CEC94EA024CED8E31D701A4C572F72@wdscexmb03.sc.wdc.com>
 <CAK7N6vpLpNM-tfhxpmym_eW+VpF+jnBe+uB=E0mSBk+CtMWp+w@mail.gmail.com>
 <5A9BC72FD5CEC94EA024CED8E31D701A4C572FAE@wdscexmb03.sc.wdc.com>
 <CAHCeSFp2=CzO1-dw_Ym_s4Pn04nsC_kQUerFJ+uFLh8iinX+Ug@mail.gmail.com>
 <CAK-9PRB7KvPNgcsXiNG08-7OdrkkNc2ushusXh9rVm93J0xcHA@mail.gmail.com> <CAHCeSFqmeOkKySxMUXgtnev+HL-NC6MdmeuDYONymYaNczb7RA@mail.gmail.com>
From: Chinmay V S <cvs268@gmail.com>
Date: Mon, 24 Sep 2012 22:37:38 +0530
Message-ID: <CAK-9PRDCvKn915AOGYLf1X1h77ZYyF_uFcfWs94zLa=xQMWt8A@mail.gmail.com>
Subject: Re: Work queue questions
To: Deepawali Verma <dverma249@gmail.com>
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>,
        anish singh <anish198519851985@gmail.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking at the timestamps in your previous logs(copied below for reference),

     kworker/u:1-21    [000]   110.964895: task_event: MYTASKJOB2381 XStarted
     kworker/u:1-21    [000]   110.964909: task_event: MYTASKJOB2381 Xstopped
     kworker/u:1-21    [000]   110.965137: task_event: MYTASKJOB2382 XStarted
     kworker/u:1-21    [000]   110.965154: task_event: MYTASKJOB2382 Xstopped
     kworker/u:5-3724  [000]   110.965311: task_event: MYTASKJOB2383 XStarted
     kworker/u:5-3724  [000]   110.965325: task_event: MYTASKJOB2383 Xstopped

110.964895 to 110.964909 is 0.014ms. The supposedly "large" amount of
copying that you assume is NOT that large. Hence the kworker thread is
able to execute your work task quickly and is again available when the
next work task is ready to be scheduled.

The "large" amount of copying that you are doing is probably too small
or being run asynchronously(DMA?) Hence the work tasks finish quickly.

On Mon, Sep 24, 2012 at 10:21 PM, Deepawali Verma <dverma249@gmail.com> wrote:
>
> Hi,
>
> This is sample code snippet as I cannot post my project code. In reality here, this work handler is copying the big chunks of data that code is here in my driver. This is running on quad core cortex A9 Thats why I have point. If there are 4 cpu cores, then there must be parallelism. Now Tajun, what do you say?
>
> Regards,
> Deepa
>
> On Monday, September 24, 2012, Chinmay V S wrote:
>>
>> There is nothing in the sub_task_work_handler() to keep the CPU occupied. Try adding a significant amount of work in it to keep it occupied. Also are you running on a SMP(multicore) system?...
>>
>> On Mon, Sep 24, 2012 at 12:55 PM, Deepawali Verma <dverma249@gmail.com> wrote:
>>>
>>> Hi Tejun,
>>>
>>> Here are some code snippets from my device driver:
>>>
>>> #defind NUMBER_OF_SUBTASKS 3
>>>
>>> struct my_driver_object
>>> {
>>>         struct workqueue_struct *sub_task_wq;
>>>         struct work_struct sub_task_work;
>>>         char my_obj_wq_name[80];
>>>         int task_id;
>>> };
>>>
>>> struct my_driver_object obj[3];
>>>
>>>
>>> void my_driver_init(void)
>>> {
>>>    int i =0;
>>>    memset(my_obj_wq_name,0,80);
>>>   --------------------------------------
>>>   for (i =0; i<3; i++)
>>>   {
>>>       snprintf(obj[i].my_obj_wq_name,80, "Task-wq:%d",i);
>>>       obj.sub_task_wq = alloc_workqueue(obj[i].my_obj_wq_name,WQ_UNBOUND,1);
>>>       INIT_WORK(&obj[i].sub_task_work, sub_task_work_handler);
>>>   }
>>>
>>>   --------------------------------------
>>> }
>>>
>>> void start_sub_tasks()
>>> {
>>>    int i =0;
>>>    for (i =0; i<3; i++)
>>>    {
>>>         queue_work(obj[i].sub_task_wq, &obj[i].sub_task_work);
>>>
>>>    }
>>>
>>>
>>> }
>>>
>>> static void sub_task_work_handler(struct work_struct work)
>>> {
>>>     Ftrace marker start;
>>>
>>>     Ftrace marker end
>>> }
>>>
>>> Ideally I was expecting when work is queued to three different work
>>> queues, it should run in parallel but it is not doing as per expected.
>>> Let me know about this.
>>>
>>> Regards,
>>> Deepa
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>> On Sat, Sep 22, 2012 at 7:18 AM, Daniel Taylor <Daniel.Taylor@wdc.com> wrote:
>>> >
>>> > ...
>>> >
>>> >> >> So on so forth.
>>> >> >> Anyway how can you write chunks of data in parallel when
>>> >> >> already some worker
>>> >> >> thread is writing i.e. the system is busy.
>>> >> >> Analogy: Suppose you are ambidextrous and you are eating.Can
>>> >> >> you eat with
>>> >> >> both of your hands at a time?So worker thread are like your
>>> >> >> hands and keeping
>>> >> >> you fed all the time is the concept of concurrency.
>>> >> >>
>>> >> >> I am not an expert on this but from Tejun's reply I could
>>> >> >> make out this.
>>> >> >> Please correct me If I have wrongly understood the concept
>>> >> >> based on this mail
>>> >> >
>>> >> > I don't know how many cores are in the CPU Deepawali's
>>> >> using, but if I have four,
>>> >> Assuming single core,Is my explanation correct about concurrency?
>>> >
>>> > It is possible for his tasks to complete before scheduling occurs
>>> > again.  Consuming all of the CPU and having no blocking action,
>>> > yes, then the tasks will run consecutively.
>>> >
>>> > ...
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
