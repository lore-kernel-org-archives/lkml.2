Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2HXVnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:43:35 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50879 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab2HXVnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:43:33 -0400
Date: Fri, 24 Aug 2012 16:43:31 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adobriyan@gmail.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
Message-ID: <20120824214331.GA19858@gulag1.americas.sgi.com>
References: <1345653510-22000-1-git-send-email-nzimmer@sgi.com> <1345660110.5158.1969.camel@edumazet-glaptop> <1345671778.5158.2369.camel@edumazet-glaptop> <20120824144852.GA18850@gulag1.americas.sgi.com> <1345820311.4824.2.camel@edumazet-laptop> <5037AFB9.5010001@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5037AFB9.5010001@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Aug 24, 2012 at 11:45:45AM -0500, Nathan Zimmer wrote:
> On 08/24/2012 09:58 AM, Eric Dumazet wrote:
>> Le vendredi 24 août 2012 à 09:48 -0500, Nathan Zimmer a écrit :
>>> On Wed, Aug 22, 2012 at 11:42:58PM +0200, Eric Dumazet wrote:
>>>> On Wed, 2012-08-22 at 20:28 +0200, Eric Dumazet wrote:
>>>>
>>>>> Thats interesting, but if you really want this to fly, one RCU
>>>>> conversion would be much better ;)
>>>>>
>>>>> pde_users would be an atomic_t and you would avoid the spinlock
>>>>> contention.
>>>> Here is what I had in mind, I would be interested to know how it helps a 512 core machine ;)
>>>>
>>> Here are the results and they look great.
>>>
>>> cpuinfo	baseline	moved kfree	Rcu
>>> tasks	read-sec	read-sec	read-sec
>>> 1	0.0141		0.0141		0.0141
>>> 2	0.0140		0.0140		0.0142
>>> 4	0.0140		0.0141		0.0141
>>> 8	0.0145		0.0145		0.0140
>>> 16	0.0553		0.0548		0.0168
>>> 32	0.1688		0.1622		0.0549
>>> 64	0.5017		0.3856		0.1690
>>> 128	1.7005		0.9710		0.5038
>>> 256	5.2513		2.6519		2.0804
>>> 512	8.0529		6.2976		3.0162
>>>
>>>
>>>
>> Indeed...
>>
>> Could you explicit the test you are actually doing ?
>>
>> Thanks
>>
>>
>
>
> It is a dead simple test.
> The test starts by forking off X number of tasks
> assigning each their own cpu.
> Each task then allocs a bit of memory.
> All tasks wait on a memory cell for the go order.
> We measure the read time starting here.
> Once the go order is given they all read a chunk of the selected proc file.
> I was using /proc/cpuinfo to test.
> Once everyone has finished we take the end read time.
>

Here is the text for those who are curious.


--fdj2RfSjLxBAspz7
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="readproc.c"


/*------------------------------------------------------------------------------------*/
char *helpstr[] = {
	"This test program is a generic template.",
	0
};

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sys/mman.h>

#include <sched.h>
#include <sys/time.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/unistd.h>

//#include "setup.h"

#define MAXCPUS                 4096
#define perrorx(s)              do { perror(s); exit(1);} while(0)
#define mb()                    asm volatile("mfence":::"memory")
#define barrier()               asm volatile("": : :"memory")
#define cpu_relax()             asm volatile ("rep;nop":::"memory");


extern int optind, opterr;
extern char *optarg;

static int verbose = 0;
static int header = 0;
static char *file = "/proc/stat";
static int numtasks = 1;
static int repeat = 1;
static int bufsize = 1024;

struct control_s {
	int ready;
	int done;
	int go;
	int exit;
} *cntl;


static cpu_set_t *defmask;
static int cpu_set_size;

static void runon_init(void)
{
        if (!defmask) {
                cpu_set_size = CPU_ALLOC_SIZE(MAXCPUS);
                defmask = CPU_ALLOC(MAXCPUS);
                if (sched_getaffinity(0, cpu_set_size, defmask) < 0)
                        perrorx("unexpected failure in runon_init");
        }
}


static double timeInSeconds(long time_in_microseconds)
{
        double temp;

        temp = time_in_microseconds;
        temp /= 1000000;

        return temp;
}

static int runon(int cpu)
{
        cpu_set_t *mask;

	runon_init();
        mask = CPU_ALLOC(MAXCPUS);
        if (cpu < 0 || cpu >= MAXCPUS)
                return -1;
        CPU_ZERO_S(cpu_set_size, mask);
        CPU_SET_S(cpu, cpu_set_size, mask);
        if (sched_setaffinity(0, cpu_set_size, mask) < 0)
                return -1;
        CPU_FREE(mask);
        return 0;
}

static long getCurrentTime()
{
        struct timeval tp;
        long usec;

        mb();
        gettimeofday(&tp, 0);
        usec = tp.tv_sec * 1000000 + tp.tv_usec;
        mb();
        return usec;
}


static void do_help(void)
{
	char **p;

	for (p = helpstr; *p; p++)
		printf("%s\n", *p);
	exit(0);
}

static void slave(int id)
{
	FILE *f;
	int i;
	char *buf;

	runon(id);
	buf = malloc(bufsize);
	memset(buf, 0, bufsize);

	if ((f = fopen(file, "r")) < 0)
		perrorx("open failed");
	while (fgets(buf, bufsize, f) != NULL) {
	}
	fclose(f);

	(void)__sync_fetch_and_add(&cntl->ready, 1);
	while (!cntl->go)
		cpu_relax();

	for (i = 0; i < repeat; i++) {
		if ((f = fopen(file, "r")) < 0)
			perrorx("open failed");
		while (fgets(buf, bufsize, f) != NULL) {
		}
		fclose(f);
		barrier();
	}

	(void)__sync_fetch_and_add(&cntl->done, 1);
	while (!cntl->exit)
		cpu_relax();
	exit(0);
}

int main(int argc, char **argv)
{
	int i, c, stat, er = 0;
	static char optstr[] = "b:f:hn:r:v";
	unsigned long t, tfork, tready, tread, texit;

	opterr = 1;
	while ((c = getopt(argc, argv, optstr)) != EOF)
		switch (c) {
		case 'b':
			bufsize = atoi(optarg);
			break;
		case 'f':
			file = optarg;
			break;
		case 'h':
			header++;
			break;
		case 'n':
			numtasks = atoi(optarg);
			break;
		case 'r':
			repeat = atoi(optarg);
			break;
		case 'v':
			verbose++;
			break;
		case '?':
			er = 1;
			break;
		}

	if (er)
		do_help();

	runon(0);
	cntl = mmap(NULL, getpagesize(), PROT_WRITE | PROT_READ, MAP_SHARED | MAP_ANONYMOUS, -1, 0);

	tfork = getCurrentTime();
	for (i = 0; i < numtasks; i++)
		if (fork() == 0)
			slave(i + 1);
	t = getCurrentTime();
	tfork = t - tfork;

	tready = t;
	while (cntl->ready != numtasks)
		usleep(1000);
	t = getCurrentTime();
	tready = t - tready;

	tread = t;
	cntl->go = 1;

	while (cntl->done != numtasks)
		cpu_relax();
	t = getCurrentTime();
	tread = t - tread;

	texit = t;
	cntl->exit = 1;
	while (wait(&stat) > 0)
		usleep(1000);
	texit = getCurrentTime() - texit;

	if (header) {
		printf("File: %s\n", file);
		printf("Bufsize: %d\n", bufsize);
		printf("Repeats: %d\n", repeat);
		printf("%6s%18s%18s%18s%18s%18s\n", "tasks", "fork-sec", "ready-sec", "read-sec", "read/repeat sec",
		       "texit");
	}
	printf("%6d%18.6f%18.6f%18.6f%18.6f%18.6f\n", numtasks, timeInSeconds(tfork), timeInSeconds(tready),
	       timeInSeconds(tread), timeInSeconds(tread) / repeat, timeInSeconds(texit));
	return 0;
}

--fdj2RfSjLxBAspz7--
