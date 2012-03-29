Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2C2OvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:51:18 -0400
Received: from fifo99.com ([67.223.236.141]:51665 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759499Ab2C2Ou7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:50:59 -0400
Date: Thu, 29 Mar 2012 07:50:56 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Bird <tim.bird@am.sony.com>, kernel-team@android.com
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
Message-ID: <20120329145055.GE13912@fifo99.com>
References: <20120328210631.GB2297@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120328210631.GB2297@fifo99.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 02:06:32PM -0700, Daniel Walker wrote:
> 
> 
> 	I went to Linaro Connect a few weeks ago. While I was there they held a
> meeting with some of the Android developers and some community developers.
> During the meeting Brian Swetland and Tim Bird were talking about upstreaming
> Android's logger kernel changes. Brian mentioned that logger was in the kernel
> for “performance reasons”. Then later Zach Pfeffer asked if Google had a test
> suite for binder. They said they didn't have anything like that, which I thought
> was really surprising. From that I assume there is no test suite for logger and
> I doubt they have any performance analysis either.
> 
> 	Since logger has a relatively simple interface I felt it would be a good
> target for performance analysis (compared to something like binder). After
> analyzing logger for a little while I decided it would be relatively easy to
> create something similar with shared memory.
> 
> 	The test case that I created uses a POSIX shared memory area as the
> storage medium. This area is different than normal shared memory in that it's
> visible as a file under /dev/shm/ . The shared memory area is protected with a
> System V semaphore. The semaphore is really overkill since contention isn't very
> likely in a real Android logging case. The writers are expected to manage the
> shared area when doing writes. This allows the logging to be daemon-less.
> 
> 	I tried to make the test as much apples to apples as possible. It is somewhat 
> difficult since logger is doing a fair amount of stuff in kernel space which may not
> be needed in userspace, or is difficult to replicate. The read side is typically used 
> infrequently and I don't think performance really matters in that case. I only really 
> address the write side, however my test case includes readers for both (not fully
> tested).
> 
> The test case was run on both x86 and ARM. Results below all in Bytes per second,
> 
> x86:
> +-----------------+----------------------+-------------------+ 
> |Clocksource      |         TSC          |       ACPI_PM     |
> +-----------------+----------------------+-------------------+
> |Shared Memory    |     457172567.4B/s   |     28708407.6B/s |
> +-----------------+----------------------+-------------------+
> |Android Logger   |      77531671.5B/s   |     79575677.3B/s |
> +-----------------+----------------------+-------------------+ 
> 
> ARM:
> +-----------------+----------------------+
> |Shared Memory    |    15336338.6B/s     |
> +-----------------+----------------------+
> |Android Logger   |     6615796.3B/s     |
> +-----------------+----------------------+
> 
> 	The x86 machine was a single core AMD 1.8Ghz machine, and the ARM was a G1
> phone with an MSM7201a SoC using a v3.3 kernel in all cases. I also used chrt to
> elevate the priority of the test case above all other processes in the system. The
> test case was run three time and averaged. The source for the test case is below.
> 
> Noticeably absent is an hpet test. I didn't have one available.
> 
> Conclusions,
> 
> 	The speed of logger isn't really dependent on the clocksource. There
> is very little change between the two clocksource runs on x86 for logger. It's because
> the bottle neck for logger isn't getting the time. The shared memory version does
> depend heavily on the speed of the clocksource. Shared memory with an ACPI_PM
> clocksource is about %64 slower than logger. In the TSC case the shared memory version
> is about %490 faster. The TSC is fast, but using VDSO it's even better.
> 
> 	On ARM it's more straight forward with the Shared Memory version being about
> %132 faster than logger.
> 
> 	As you can see there are some trade offs on x86. I should note that there are
> Android phones being made with x86 platforms. So this isn't as ridiculous as it might
> seem. I would guess most of those phones don't have ACPI_PM clocks however.
> 
> 	I made no attempt to address any security issues in logger. Since logger has
> no security built into it currently. There are at least two ways to provide security
> to the shared memory interface that I know of, but I'm not planning to discuss them in
> this analysis.
> 
> I welcome comments on the test case, or my analysis.
>  
> Here's the test case used,
> 
> 
> /*
>  * Copyright (c) 2012, Daniel Walker <dwalker@fifo99.com>
>  *
>  * gcc -O2 logger_test.c -lrt -lpthread -o logger_test
>  *
>  */
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <string.h>
> #include <signal.h>
> 
> #include <fcntl.h>
> #include <time.h>
> #include <pthread.h>
> #include <errno.h>
> 
> #include <stdint.h>
> #include <semaphore.h>
> #include <sys/mman.h>
> #include <sys/types.h>
> #include <sys/time.h>
> #include <sys/stat.h>
> #include <sys/uio.h>
> 
> char buffer[1024] = { [0 ... 1023] = '0' };
> 
> struct timeval tv1, tv2;
> 
> struct memory_control_area {
> 	sem_t mutex;
> 	unsigned long start, end, size, readers;
> 	_Bool overwrite;
> 	char data[0];
> };
> 
> _Bool stopped = 0;
> 
> #define READ_WAIT_FIFO_NAME	"/tmp/shared_memory_reader_fifo"
> int read_wait_fifo;
> 
> void alarm_handler(int signal)
> {
> 	stopped = 1;
> }
> 
> struct sigaction alarm_overload = {
> 	.sa_handler = alarm_handler,
> };
> 
> void int_handler(int signal)
> {
> 	stopped = 1;
> }
> 
> struct sigaction int_overload = {
> 	.sa_handler = int_handler,
> };
> 
> /*
>  *  This is for compatibility with Android logger
>  */
> #define CONTENT_LINES (64)
> 
> /*
>  *  Size of the memory area. This is minus the control structure.
>  */
> #define CONTENT_SIZE (CONTENT_LINES*1024 - sizeof(struct memory_control_area))
> 
> /*
>  * Subtracts tv1 from tv2 and prints the output.
>  */
> void print_diff_time(char header[], struct timeval *tv1, struct timeval *tv2, unsigned long long bytes)
> {
> 	unsigned long long diff_useconds, diff_seconds;
> 	double total_time;
> 
> 	diff_useconds = (tv2->tv_usec + (tv2->tv_sec*1000000)) -
> 			(tv1->tv_usec + (tv1->tv_sec*1000000)),
> 
> 	total_time = diff_useconds/1000000.0;
> 
> 	printf("%s wrote %llu bytes in %.1f seconds at a rate of %.1f Bytes/second\n",
> 		header, bytes, total_time, (double)(bytes/total_time));
> }
> 
> char *sample_log_string(void)
> {
> 	/*
> 	 *  Just some sample logs for effect.
> 	 */
> 	static char *sample_msgs[16] = {
> 		"New MMC card '00000' (serial 2029453699) added @ /devices/platform/msm_sdcc.2/mmc_host/mmc1/mmc1:0001\n",
> 		"Disk (blkdev 179:0), 7954432 secs (3884 MB) 1 partitions\n",
> 		"New blkdev 179.0 on media 00000, media path /devices/platform/msm_sdcc.2/mmc_host/mmc1/mmc1:0001, Dpp 1\n",
> 		"Partition (blkdev 179:1), 7946240 secs (3880 MB) type 0xb\n",
> 		"New blkdev 179.1 on media 00000, media path /devices/platform/msm_sdcc.2/mmc_host/mmc1/mmc1:0001, Dpp 0\n",
> 		"Evaluating dev '/devices/platform/msm_sdcc.2/mmc_host/mmc1/mmc1:0001/block/mmcblk0' for mountable filesystems for '/sdcard'\n",
> 		"handle_switch_event(): Ignoring switch 'No Device'\n",
> 		"Bootstrapping complete\n",
> 		"dosfsck 3.0.1 (23 Nov 2008)\n",
> 		"akmd 1.6.4 START \n",
> 		"library version: 1.2.1.1129\n",
> 		"dosfsck 3.0.1, 23 Nov 2008, FAT32, LFN\n",
> 		"Logical sector size is zero.\n",
> 		"/system/bin/dosfsck terminated by exit(8)\n",
> 		"Filesystem check failed (not a FAT filesystem)\n",
> 		"vfat filesystem check failed on 179:1 (No data available)\n",
> 	};
> 
> 	static index = 0;
> 	
> 	if (index >= 16) {
> 		index = 0;
> 	}
> 
> 	return sample_msgs[index++];
> }
> 
> void register_signal_handler(int sig, struct sigaction *overload)
> {
> 	int ret = sigaction(sig, overload, NULL);
> 	if (ret < 0) {
> 		perror("sigaction():");
> 		exit(1);
> 	}
> 
> }
> 
> enum fifo_direction {
> 	FIFO_READ,
> 	FIFO_WRITE,
> };
> 
> int open_fifo(enum fifo_direction dir)
> {
> 	int ret = open(READ_WAIT_FIFO_NAME, (dir == FIFO_READ) ? O_RDONLY : O_WRONLY);
> 	if (ret < 0) {
> 		perror("open():");
> 		exit(1);
> 	}
> 	
> }
> 
> /*
>  *  Test this kernels logger interface in /dev/log/
>  */
> void test_logger(int seconds)
> {
> 	int fd, i, ret, prio = 4;
> 	unsigned long long bytes_written = 0;
> 	const char *tag = "";
> 	unsigned long long j;
>     	struct iovec vec[3];
> 
> 	gettimeofday(&tv1, NULL);
> 
> 	fd = open("/dev/log_main", O_WRONLY);
> 	if (fd < 0) {
> 		perror("open():");
> 		exit(1);
> 	}
> 	
> 	stopped = 0;
> 
> 	alarm(seconds);
> 
> 	vec[0].iov_base	= (unsigned char *) &prio;
> 	vec[0].iov_len	= 1;
> 	vec[1].iov_base	= (void *) tag;
> 	vec[1].iov_len	= 1;
> 
> 	while (!stopped) {
> 		char *buffer = sample_log_string();
> 
> 		vec[2].iov_base	= (void *) buffer;
> 		vec[2].iov_len	= strlen(buffer); /* Don't include the null */
> 
> 		ret = writev(fd, vec, 3);
> 		if (ret < 0) {
> 			perror("writev():");
> 			exit(1);
> 		}
> 		bytes_written += ret;
> 	}
> 
> 	close(fd);
> 
> 	gettimeofday(&tv2, NULL);
> 
> 	print_diff_time("Android logger", &tv1, &tv2, bytes_written);	
> }
> 
> void logger_reader()
> {
> 	char buffer[1024];
> 	struct logger_entry {
> 	    uint16_t    len;    /*  length of the payload */
> 	    uint16_t    __pad;  /*  no matter what, we get 2 bytes of padding */
> 	    int32_t     pid;    /*  generating process's pid */
> 	    int32_t     tid;    /*  generating process's tid */
> 	    int32_t     sec;    /*  seconds since Epoch */
> 	    int32_t     nsec;   /*  nanoseconds */
> 	    char        msg[0]; /*  the entry's payload */
> 	} *casted_buffer = (struct logger_entry *)buffer;
> 
> 	int i, size, fd, prio = 0;
> 	struct iovec vec[3]; 
> 	const char *tag = "";
> 
> 	vec[0].iov_base = (void *) buffer,
> 	vec[0].iov_len = 1024,
> 
> 	fd = open("/dev/log_main", O_RDONLY);
> 	if (fd < 0) {
> 		perror("open():");
> 		exit(1);
> 	}
> 
> 	while (size = readv(fd, vec, 1)) { 
> 		for(i = 1; i < casted_buffer->len; i++) {
> 			printf("%c", casted_buffer->msg[i]);
> 		}
> 	}
> 	close(fd);	
> }
> 
> /*
>  *  Test write into shared memory
>  */
> void test_shared_memory(int seconds)
> {
> 	struct memory_control_area *shared_area;
> 	unsigned long long bytes_written = 0;
> 	int fd, i, ret;
> 
> 	stopped = 0;
> 
> 	if (seconds == 0) {
> 		register_signal_handler(SIGINT, &int_overload);
> 	} else {
> 		alarm(seconds);
> 	}
> 
> 	gettimeofday(&tv1, NULL);
> 
> 	fd = shm_open("/shared_memory_test", O_CREAT | O_RDWR, S_IRUSR | S_IRGRP | S_IWUSR | S_IWGRP);
> 	if (fd < 0) {
> 		perror("shm_open():");
> 		exit(1);
> 	}
> 
> 	ret = ftruncate(fd, CONTENT_SIZE);
> 	if (ret < 0) {
> 		perror("ftruncate():");
> 		exit(1);
> 	}
> 
> 	shared_area = (struct memory_control_area *)mmap(NULL, CONTENT_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_LOCKED, fd, 0);
> 	if (shared_area == MAP_FAILED) {
> 		perror("mmap():");
> 		exit(1);
> 	}
> 
> 	while (!stopped) {
> 		char *buffer = sample_log_string();
> 		int buffer_size = strlen(buffer); /* don't write the null */
> 		struct timeval sample;
> 
> 		sem_wait(&shared_area->mutex);
> 		
> 		/*
> 		 *  This isn't used but it's here for compatibility with
> 		 *  logger. Since logger samples the time on each write.
> 		 *  This can also be a delay sink depending on which clocksource
> 		 *  your using.
> 		 */
> 		gettimeofday(&sample, NULL);
> 
> 		/*
> 		 *  Two cases. The first one handles when the buffer loops
> 		 *  around to the start, the second is just a regular write.
> 		 */
> 		if(shared_area->end + buffer_size >= CONTENT_SIZE)
> 		{
> 			unsigned long rem = CONTENT_SIZE - shared_area->end;
> 	
> 			memcpy(shared_area->data + shared_area->end, buffer, rem);
> 
> 			/* Loop around to the start of the buffer */
> 			shared_area->end = 0;
> 
> 			memcpy(shared_area->data + shared_area->end, buffer + rem, buffer_size - rem);
> 			
> 			shared_area->end = buffer_size - rem;
> 
> 			shared_area->overwrite = 1;
> 
> 		} else {
> 			memcpy(shared_area->data + shared_area->end, buffer, buffer_size);
> 			shared_area->end += buffer_size;
> 		}
> 
> 		if (shared_area->overwrite)
> 			shared_area->start = shared_area->end + 1;
> 
> 		sem_post(&shared_area->mutex);
> 
> 		bytes_written += buffer_size; 
> 	}
> 
> 	close(fd);
> 
> 	gettimeofday(&tv2, NULL);
> 
> 	print_diff_time("Shared memory", &tv1, &tv2, bytes_written);	
> 
> }
> 
> void init_shared_memory_file(void)
> {
> 	struct memory_control_area *shared_area;
> 	int fd, ret, i;
> 
> 	fd = shm_open("/shared_memory_test", O_CREAT | O_RDWR, S_IRUSR | S_IRGRP | S_IWUSR | S_IWGRP);
> 	if (fd < 0) {
> 		perror("shm_open():");
> 		exit(1);
> 	}
> 
> 	ret = ftruncate(fd, CONTENT_SIZE);
> 	if (ret < 0) {
> 		perror("ftruncate():");
> 		exit(1);
> 	}
> 
> 	shared_area = (struct memory_control_area *)mmap(NULL, CONTENT_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_LOCKED, fd, 0);
> 	if (shared_area == MAP_FAILED) {
> 		perror("mmap():");
> 		exit(1);
> 	}
> 
> 	/* Warm up the shared memory area */
> 	for (i = 0; i < CONTENT_SIZE - sizeof(struct memory_control_area); i++)
> 		shared_area->data[i] = 0;
> 
> 	sem_init(&shared_area->mutex, 1, 1);
> 
> 	shared_area->readers = 0;
> 	shared_area->start = 0;
> 	shared_area->end = 0;
> 
> 	close(fd);
> }
> 
> void shared_memory_reader()
> {
> 	int fd, i, ret, bytes_to_read, bytes_read = 0;
> 	struct memory_control_area *shared_area;
> 	char output_buf[1024];
> 
> 	fd = shm_open("/shared_memory_test", O_CREAT | O_RDWR, S_IRUSR | S_IRGRP | S_IWUSR | S_IWGRP);
> 	if (fd < 0) {
> 		perror("shm_open():");
> 		exit(1);
> 	}
> 
> 	ret = ftruncate(fd, CONTENT_SIZE);
> 	if (ret < 0) {
> 		perror("ftruncate():");
> 		exit(1);
> 	}
> 
> 	shared_area = (struct memory_control_area *)mmap(NULL, CONTENT_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_LOCKED, fd, 0);
> 	if (shared_area == MAP_FAILED) {
> 		perror("mmap():");
> 		exit(1);
> 	}
> 	
> 	bytes_to_read = CONTENT_SIZE - shared_area->end;
> 
> 	while (bytes_to_read) {
> 		if (bytes_to_read >= 1024) {
> 			memcpy(output_buf, shared_area->data + shared_area->end + bytes_read, 1024);
> 			bytes_read += 1024;
> 			bytes_to_read -= 1024;
> 		} else {
> 			memcpy(output_buf, shared_area->data + shared_area->end + bytes_read, bytes_to_read);
> 			bytes_read += bytes_to_read;
> 			bytes_to_read = 0;
> 		}
> 		
> 		for(i = 0; i < 1024; i++)
> 			printf("%c", output_buf[i]);	
> 	}
> 	
> 	bytes_to_read = shared_area->end;
> 
> 	while (bytes_to_read) {
> 		if (bytes_to_read >= 1024) {
> 			memcpy(output_buf, shared_area->data + bytes_read, 1024);
> 			bytes_read += 1024;
> 			bytes_to_read -= 1024;
> 		} else {
> 			memcpy(output_buf, shared_area->data + bytes_read, bytes_to_read);
> 			bytes_read += bytes_to_read;
> 			bytes_to_read = 0;
> 		}
> 
> 		for(i = 0; i < 1024; i++)
> 			printf("%c", output_buf[i]);
> 	}
> }
> 
> int main(int argc, char *argv[])
> {
> 	char help[] =	"Android Logger Performance Tester\n"
> 			"\n"
> 			"Options:\n"
> 			"-l:	Test android logger in /dev/log/ (default)\n"
> 			"-s:	Test shared memory in /dev/shm\n"
> 			"	Must be mount with a command similar to \"mount -t tmpfs none /dev/shm\"\n"
> 			"-n X:	Number of seconds to run the test (default 60, 0 == unlimited)\n"
> 			"-i:	Initialize shared memory file\n"
> 			"-r:	Run shared memory reader\n"
> 			"-t:	Run logger reader\n"
> 			"\n";			
> 
> 	int c, ret;
> 	int seconds = 60;
> 
> 	ret = mlockall(MCL_CURRENT | MCL_FUTURE);
> 	if (ret < 0) {
> 		perror("mlockall():");
> 		exit(1);
> 	}
> 
> 	register_signal_handler(SIGALRM, &alarm_overload);
> 
> 	if (access(READ_WAIT_FIFO_NAME, F_OK) < 0) {
> 		ret = mkfifo(READ_WAIT_FIFO_NAME, S_IWUSR | S_IWGRP | S_IRUSR | S_IRGRP);
> 		if (ret < 0) {
> 			perror("mkfifo():");
> 			exit(1);
> 		}
> 	}
> 
> 	while ((c = getopt(argc, argv, "hiutlsrn:")) != -1)  {
> 
> 		switch (c) {
> 			case 'h':
> 				printf("%s\n", help);
> 				break;	
> 			case 'u':
> 				if (shm_unlink("/shared_memory_test") != 0) {
> 					perror("shm_unlink():");
> 					exit(1);
> 				}
> 			case 'i':
> 				init_shared_memory_file();
> 				break;
> 			case 'l':
> 				test_logger(seconds);
> 				break;
> 			case 's':
> 				test_shared_memory(seconds);
> 				break;
> 			case 'r':
> 				shared_memory_reader();
> 				break;
> 			case 't':
> 				logger_reader();
> 				break;
> 			case 'n':
> 				errno = 0;
> 				seconds = strtoll(optarg, NULL, 10);
> 				if (errno != 0) {
> 					perror("strtol():");
> 					exit(1);
> 				}
> 		}
> 	}
> 
> 	return 0;
> }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
