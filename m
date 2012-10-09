Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2JIJuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:50:04 -0400
Received: from mail.abmm.hu ([195.228.156.64]:48662 "EHLO mail.abmm.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab2JIJuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:50:00 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2012 05:49:59 EDT
Message-ID: <5073F13C.5050807@thx4games.com>
Date: Tue, 09 Oct 2012 11:41:16 +0200
From: Viktor Nagy <viktor.nagy@thx4games.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Linux 3.0+ Disk performance problem - wrong pdflush behaviour
Content-Type: multipart/mixed;
 boundary="------------000101090109090408010501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000101090109090408010501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Since Kernel version 3.0 pdflush blocks writes even the dirty bytes are 
well below /proc/sys/vm/dirty_bytes or /proc/sys/vm/dirty_ratio.
The kernel 2.6.39 works nice.

How this hurt us in the real life: We have a very high performance game 
server where the MySQL have to do many writes along the reads. All 
writes and reads are very simple and have to be very quick. If we run 
the system with Linux 3.2 we get unacceptable performance. Now we are 
stuck with 2.6.32 kernel here because this problem.

I attach the test program wrote by me which shows the problem. The 
program just writes blocks continously to random position to a given big 
file. The write rate limited to 100 MByte/s. In a well-working kernel it 
have to run with constant 100 MBit/s speed for indefinite long. The test 
have to be run on a simple HDD.

Test steps:
1. You have to use an XFS, EXT2 or ReiserFS partition for the test, Ext4 
forces flushes periodically. I recommend to use XFS.
2. create a big file on the test partiton. For 8 GByte RAM you can 
create a 2 GByte file. For 2 GB RAM I recommend to create 500MByte file. 
File creation can be done with this command:  dd if=/dev/zero 
of=bigfile2048M.bin bs=1M count=2048
3. compile pdflushtest.c: (gcc -o pdflushtest pdflushtest.c)
4. run pdflushtest: ./pdflushtest --file=/where/is/the/bigfile2048M.bin

In the beginning there can be some slowness even on well-working 
kernels. If you create the bigfile in the same run then it runs usually 
smootly from the beginning.

I don't know a setting of /proc/sys/vm variables which runs this test 
smootly on a 3.2.29 (3.0+) kernel. I think this is a kernel bug, because 
if I have much more "/proc/sys/vm/dirty_bytes" than the testfile size 
the test program should never be blocked.

A sample result:
11:20:05: speed:   99.994 MiB/s, time usage:  4.60 %, avg. block 
time:    1.8 us, max. block time: 18 us
11:20:06: speed:   99.994 MiB/s, time usage:  4.60 %, avg. block 
time:    1.8 us, max. block time: 10 us
11:20:07: speed:   99.994 MiB/s, time usage:  4.62 %, avg. block 
time:    1.8 us, max. block time: 11 us
11:20:08: speed:   99.989 MiB/s, time usage:  4.59 %, avg. block 
time:    1.8 us, max. block time: 58 us
11:20:09: speed:   99.997 MiB/s, time usage:  4.55 %, avg. block 
time:    1.8 us, max. block time: 13 us
11:20:10: speed:   28.840 MiB/s, time usage: 96.47 %, avg. block time:  
130.7 us, max. block time: 114076 us
11:20:11: speed:   30.505 MiB/s, time usage: 98.14 %, avg. block time:  
125.7 us, max. block time: 135008 us
11:20:12: speed:   25.956 MiB/s, time usage: 99.71 %, avg. block time:  
150.1 us, max. block time: 129839 us
11:20:13: speed:   25.088 MiB/s, time usage: 96.43 %, avg. block time:  
150.1 us, max. block time: 149649 us
11:20:14: speed:   32.438 MiB/s, time usage: 98.64 %, avg. block time:  
118.8 us, max. block time: 145649 us
11:20:15: speed:   22.765 MiB/s, time usage: 99.11 %, avg. block time:  
170.1 us, max. block time: 159749 us

At 11:20:10 the pdflush started its work, based on the 
"dirty_expire_centisecs". The test file was 2GByte, the 
/proc/sys/vm/dirty_bytes/dirty_bytes was 4000000000. The system (i5-3.4 
GHz, 8G RAM, Kernel 3.2.29-amd64) was booted to run this test only so it 
had 2,2 GByte RAM for cache, and 5.1 GByte RAM free (totally unused).

Sorry if I not found the right place to report this, please advise me 
were to send.

Best regards
Viktor Nagy

--------------000101090109090408010501
Content-Type: text/x-csrc;
 name="pdflushtest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pdflushtest.c"


#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <inttypes.h>
#include <sys/time.h>
#include <time.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h> 

// parameters

char * filename = NULL;
enum testermode {READ, WRITE} mode = WRITE;
float speedlimit = 100; // MiB / s
int burstcount = 10;

// internals

int blocksize = 4096;
int blockcount = 0;

int fh = 0;

char filebuffer[65536];

static struct option long_options[] = 
{
	{"mode",     required_argument, 0,  0 },
	{"m",     required_argument, 0,  0 },
	{"file",    required_argument, 0,  0 },
	{"f",    required_argument, 0,  0 },
	{"limit",    required_argument, 0,  0 },
	{"l",    required_argument, 0,  0 },
	{"burst",    required_argument, 0,  0 },
	{"b",    required_argument, 0,  0 },
	{0,         0,                 0,  0 }
};

void parse_commandline(int argc, char **argv)
{
	int r;
	int option_index = 0;
    
    while (0 <= (r = getopt_long_only(argc, argv, "", long_options, &option_index)))
    {
        const char * optname = long_options[option_index].name;
		if (r == 0)
		{			
			if (strcmp("file", optname) == 0 || strcmp("f", optname) == 0)
			{
				filename = strdup(optarg);
			}
			else if (strcmp("mode", optname) == 0 || strcmp("m", optname) == 0)
			{
				if (strcmp("reader", optarg) == 0 || strcmp("read", optarg) == 0)
				{
					mode = READ;
				}
				else if (strcmp("writer", optarg) == 0 || strcmp("write", optarg) == 0)
				{
					mode = WRITE;
				}
				else
				{
					printf("Invalid mode: \"%s\"\n", optarg);
				}
			}
			else if (strcmp("burst", optname) == 0 || strcmp("b", optname) == 0)
			{
				burstcount = atoi(optarg);
				if (burstcount < 1)  burstcount = 1;
			}
			else if (strcmp("limit", optname) == 0 || strcmp("l", optname) == 0)
			{
				speedlimit = atoi(optarg);
				if (speedlimit < 1)  speedlimit = 1;
			}
			else
			{
				printf("Unhandled option: \"%s\"\n", optname);
			}
		}
		else
		{
			exit(1);
			break;
		}
	}
}

char * getmodename(enum testermode amode)
{
    if (READ == amode)  return "reader";
    if (WRITE == amode)  return "writer";
    return "unknown";
}

int64_t getusecs()
{
	struct timeval tv;
	struct timezone tz;
	gettimeofday(&tv, &tz);
	return (tv.tv_sec * 1000000 + tv.tv_usec);
}

void print_timestamp()
{
	struct tm *tmp;
    time_t t;
    char outstr[200];
    
	t = time(NULL);
    tmp = localtime(&t);
    
	if (strftime(outstr, sizeof(outstr), "%H:%M:%S", tmp) == 0) 
	{
        return;
    }	
    printf("%s", outstr);
}

void read_block(int blockindex)
{
	lseek(fh, blockindex * blocksize, SEEK_SET);
	
	int64_t r = read(fh, &filebuffer, blocksize);
	
	if (r <= 0)
	{
		printf("Error reading block %i\n", blockindex);
		exit(1);
	}
}

void write_block(int blockindex)
{
	lseek(fh, blockindex * blocksize, SEEK_SET);
	
	int64_t r = write(fh, &filebuffer, blocksize);
	
	if (r <= 0)
	{
		printf("Error writing block %i\n", blockindex);
		exit(1);
	}
}

void run_worker()  // generates disk writes
{
	printf("Running %s...\n", getmodename(mode));
	
	int bcnt = 0;
	int64_t bytecnt = 0;
	int n;
	
	int64_t t1 = getusecs();
	int64_t t2 = 0;
	float interval = 0;
	float speed = 0;
	
	int64_t worktime = 0;
	
	int64_t maxblocktime = 0;
	
	while (1)
	{		
		int64_t bwt1 = getusecs();
		
		// some burst read
		for (n = 1; n <= burstcount; n++)
		{
			int bi = rand() % blockcount;			
			int64_t sbt1 = getusecs();
			if (WRITE == mode)
			{
				write_block(bi);			
			}
			else
			{
				read_block(bi);
			}
			int64_t sblocktime = getusecs() - sbt1;
			if (maxblocktime < sblocktime)  maxblocktime = sblocktime;
			bcnt++;
			bytecnt += blocksize;
		}
		
		worktime += (getusecs() - bwt1);
				
		// some wait						
		while (1)
		{		
			t2 = getusecs();
			
			interval = (float) (t2 - t1) / 1000000.;

			speed = (float) bytecnt / (interval * 1024. * 1024.);
			
			if ((speed > speedlimit) && (interval < 1))
			{
				usleep(100);
			}  
			else
			{
				break;
			}
		} 
		
		if (interval >= 1)
		{
			float avgblocktime = (float) worktime / (float) bcnt;
					
			print_timestamp();
			printf(": speed: %8.3f MiB/s, time usage: %5.2f %%, avg. block time: %6.1f us, max. block time: %ld us\n", 
			   speed,
			   100 * ((float) worktime / 1000000.) / interval, 
			   avgblocktime,
			   maxblocktime 
			);
			
			if (interval > 1.1)
			{
				printf("  Work was blocked for a long time! Test interval: %8.3f s\n", interval);
			}
			
			t1 = getusecs();
			bcnt = 0;
			bytecnt = 0;
			worktime = 0;
			maxblocktime = 0;
		}
	}
}

int main(int argc, char **argv)
{
	struct stat sst;
	
	srand(time(NULL));
	
	printf("Linux kernel pdflush tester\n\n");
	printf("Usage: pdflushtest --mode read|write --file filename\n");
	printf("Options:\n  --limit x : limit the maximal speed to x MiB/s\n");
	printf("  --burst x : do the work with x block bursts\n\n");
	
    parse_commandline(argc, argv);
           
    printf("Current parameters: \n");    
    printf("  mode: %s\n", getmodename(mode));
    printf("  file: %s\n", filename);
    printf("  burst length: %i\n", burstcount);
    printf("  speed limit: %f MiB/s\n", speedlimit);
    printf("\n");
    
    // getting scratchfile parameters
    
    printf("Working file \"%s\":\n", filename);
    
    if (stat(filename, &sst) == 0)
    {
		blocksize = sst.st_blksize;
		blockcount = sst.st_size / blocksize;
		
		printf("  size: %ld\n", sst.st_size);
		printf("  blocksize: %i\n", blocksize);
		printf("  number of blocks: %i\n", blockcount);
	}
	else
	{
		printf("Error getting info for file \"%s\"\n", filename);
		exit(1);
	}
	
    printf("\n");
    
	fh = open(filename, O_RDWR);	
	if (fh < 0)
	{
		printf("Error opening file \"%s\"\n", filename);
		exit(1);
	}
	
	run_worker();
        
    printf("finished.\n");
       
    return 0;
}


--------------000101090109090408010501--
