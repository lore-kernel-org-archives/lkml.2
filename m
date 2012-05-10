Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2EJOBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:01:04 -0400
Received: from mail.jpberlin.de ([213.203.238.11]:56765 "EHLO mail.jpberlin.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab2EJOBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:01:00 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2012 10:01:00 EDT
Message-ID: <4FABC7A1.9010003@jpberlin.de>
Date: Thu, 10 May 2012 15:50:25 +0200
From: Thomas Bechtold <thomasbechtold@jpberlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20120430 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Subject: reliable write to micro sd-card with O_SYNC and O_DIRECT not possible
Content-Type: multipart/mixed;
 boundary="------------010104070305050202060809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010104070305050202060809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

i tried to write some pages (each 512 byte) to a industrial micro
sd-card (from delkin devices, 2 GB) with O_SYNC and O_DIRECT but the
write process is not reliable when i remove the card.
i do the following:

1) open the device (with O_DIRECT and O_SYNC)
2) write the page to the card
3) close the device
4) open the device
5) read the page
6) compare the read page with the written page
7) if both pages are equal, the page-write was successful. otherwise, an
error code is returned.

The strange thing is, that my write-process returns successfully
(written and read page are equal)but when i later read the card, some
pages are empty.

I can reproduce this behavior with the attached testprogram when i do
the following:

1) start the program with ./mmc-test write    //and fix the device path
MEMORY_DEVICE_PATH before you start the program
2) remove and attach the memory card 10x
3) start the program with ./mmc-test read

now there are some pages which should be successfully written, but in
fact are unavailable.

i tested this with a usb-mmc-card adapter on i386 (debian 3.2 backports
kernel)and with the atmel-mci driver on arm at91 platform (3.2.16
upstream kernel).

TIA,

Tom

--------------010104070305050202060809
Content-Type: text/x-csrc;
 name="mmc-write.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mmc-write.c"

/**
 * Test page write on linux (thomasbechtold@jpberlin.de)
 *
 * Compile with: gcc -o mmc-test mmc-write.c
 * 
 * Usage: ./mmc-test write      //write to the given device some pages
 * Usage: ./mmc-test read       //read the pages from the device
 *
 *
 * show the written pages with hexdump: for X in {0..800}; do hexdump -C /dev/sdb -n 5 -s "$X"b; done
 */

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


#define PAGE_SIZE 512
#define MESSAGE_LENGTH 100

/* CHANGE THIS TO YOUR MMC DEVICE PATH */
#define MEMORY_DEVICE_PATH "/dev/sdb"


/* print the given message to stdout but if the same message was already printed, just print a '*' */
void myprint (char *message)
{
	static char message_cache[MESSAGE_LENGTH];
	if (memcmp (message, &message_cache, MESSAGE_LENGTH) == 0)
	{
		// same message again
		printf ("*");
	}
	else
	{
		// new message
		printf ("\n%s ", message);
		memcpy (&message_cache, message , MESSAGE_LENGTH);
	}
}

void write_page (unsigned long id)
{
	//the page we want to write
	char page[PAGE_SIZE] = { 0 };
	page[0] = 'P';
	memcpy (&page[1], &id, sizeof (unsigned long));

	//file descriptor to write and read the page
	int memory_fd = -1;

	//loop as long as the page-write (and read) was unsucessful
	while (1)
	{
		//buffer for a console message
		char message[100] = { 0 };

		close (memory_fd);
		memory_fd = -1;

		errno = 0;
		memory_fd = open (MEMORY_DEVICE_PATH, O_RDWR, O_SYNC | O_DIRECT);
		if (memory_fd >= 0)
		{
			//seek to correct position (to write the page)
			off_t lseek_write_res = -1;
			errno = 0;
			lseek_write_res = lseek (memory_fd, id * PAGE_SIZE, SEEK_SET);
			if (lseek_write_res == -1 || lseek_write_res != id * PAGE_SIZE)
			{
				sprintf (message, "%lu: seek failed: %s\n", id, strerror (errno));
				myprint (message);
				continue;
			}

			//write page
			errno = 0;
			ssize_t write_res = 0;
			write_res = write (memory_fd, &page, PAGE_SIZE);
			if (write_res == -1 || write_res != PAGE_SIZE)
			{
				sprintf (message, "%lu: write failed: %s\n", id, strerror (errno));
				myprint (message);
				continue;
			}

			//close and reopen the device to read and check the page
			close (memory_fd);
			memory_fd = open (MEMORY_DEVICE_PATH, O_RDONLY);

			//seek to correct position (to read the written page)
			errno = 0;
			off_t lseek_read_res = -1;
			lseek_read_res = lseek (memory_fd, id * PAGE_SIZE, SEEK_SET);
			if (lseek_read_res == -1 || lseek_read_res != id * PAGE_SIZE)
			{
				sprintf (message, "%lu: seek failed: %s\n", id, strerror (errno));
				myprint (message);
				continue;
			}

			//read the written page
			char page_read[PAGE_SIZE] = { 0 };
			errno = 0;
			ssize_t read_res = 0;
			read_res = read (memory_fd, &page_read, PAGE_SIZE);
			if (read_res == -1 || read_res != PAGE_SIZE)
			{
				sprintf (message, "%lu: read failed: %s\n", id, strerror (errno));
				myprint (message);
				continue;
			}
			
			//compare the written page with the read page
			if (memcmp (&page, &page_read, sizeof (PAGE_SIZE)) != 0)
			{
				sprintf (message, "%lu: compare failed.\n", id);
				myprint (message);
				continue;
			}

			//wrote successfully the page
			break;
		}
		else
		{
			sprintf (message, "%lu: open failed: %s\n", id, strerror (errno));
			myprint (message);
		}
		
	}
	close (memory_fd);
	printf ("\n%lu: sucessfully written", id);
}

void read_page (unsigned long id)
{
	char page[PAGE_SIZE] = { 0 };
	page[0] = 'P';
	memcpy (&page[1], &id, sizeof (unsigned long));
	int memory_fd = -1;
	// open device
	while (1)
	{
		errno = 0;
		close (memory_fd);
		memory_fd = -1;
		//memory_fd = open (MEMORY_DEVICE_PATH, O_DIRECT | O_SYNC, O_RDWR);
		memory_fd = open (MEMORY_DEVICE_PATH, O_RDWR);
		if (memory_fd >= 0)
		{
			//seek to correct position (to read the written page)
			errno = 0;
			off_t lseek_read_res = -1;
			lseek_read_res = lseek (memory_fd, id * PAGE_SIZE, SEEK_SET);
			if (lseek_read_res == -1 || lseek_read_res != id * PAGE_SIZE)
			{
				printf ("%lu: seek failed: %s\n", id, strerror (errno));
				continue;
			}

			//read the written page
			char page_read[PAGE_SIZE] = { 0 };
			errno = 0;
			ssize_t read_res = 0;
			read_res = read (memory_fd, &page_read, PAGE_SIZE);
			if (read_res == -1 || read_res != PAGE_SIZE)
			{
				printf ("%lu: read failed: %s\n", id, strerror (errno));
				continue;
			}

			//compare page
			if (memcmp (&page, &page_read, sizeof (PAGE_SIZE)) != 0)
			{
				printf ("%lu: compare failed.\n", id);
				close (memory_fd);
				exit (-1);
			}
			//read successfully the page
			break;
		}
		else
		{
			printf ("%lu: open failed: %s\n", id, strerror (errno));
		}
		
	}
	close (memory_fd);
}


int main (int argc, char *argv[])
{
	if (argc != 2)
	{
		printf ("please tell mode: 'read' or 'write'\n");
		exit (-1);
	}
	//function to use for the loop
	void (*mode)(unsigned long) = NULL;
	if (strcmp (argv[1], "read") == 0)
	{
		mode = &read_page;
	}
	else if (strcmp (argv[1], "write") == 0)
	{
		mode = &write_page;
	}
	else
	{
		printf ("unknown mode '%s'\n", argv[1]);
		exit (-1);
	}


	unsigned long x;
	for (x = 0; ; x++ )
	{
		
		mode (x);
	}
	printf ("\n");
	exit(EXIT_SUCCESS);
}

--------------010104070305050202060809--
